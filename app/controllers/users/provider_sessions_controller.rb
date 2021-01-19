class Users::ProviderSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  # POST /users/loginProvider
  def create
    resource = ::Users::FindOrCreate.perform(allowed_params: allowed_params)
    crete_token(resource)
    add_order(resource)
    respond_with resource
  end

  private

  def crete_token(resource)
    payload = resource.jwt_payload.merge(resource.jwt_exp)
    token = JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    response.headers['Authorization'] = "Bearer #{token}"
  end

  def add_order(resource)
    return unless resource.present?
    return unless order_by_token.present?

    order_by_token.user_id = resource.id
    order_by_token.save
  end

  def respond_with(resource)
    render json: { success: true,
                   message: 'Se inicio sesion con exito',
                   user: UserSerializer.new(resource) },
           status: 200
  end

  def allowed_params
    params.require(:user).permit(:name, :lastname, :email, :provider, :uid)
  end
end
