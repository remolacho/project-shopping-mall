class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { success: true, message: 'Se inicio sesion con exito', user: UserSerializer.new(resource) }, state: 200
  end

  def respond_to_on_destroy
    head :ok
  end
end
