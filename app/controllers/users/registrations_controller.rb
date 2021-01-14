class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    attributes = %i[name lastname rut password password_confirmation gender birthdate image]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  private

  def respond_with(resource, _opts = {})
    success = true
    message = 'Usuario creado con exito'
    status = 200

    unless resource.persisted?
      success = false
      message = resource.errors.full_messages.join(', ')
      status = 401
    end

    add_role(resource)
    add_order(resource)

    render json: { success: success, message: message, user: UserSerializer.new(resource) }, status: status
  end

  def add_role(resource)
    resource.add_role :buyer if resource.persisted?
  end

  def add_order(resource)
    return unless resource.persisted?
    return unless order_by_token.present?

    order_by_token.user_id = resource.id
    order_by_token.save
  end
end
