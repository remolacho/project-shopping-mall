module ManageException
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from PolicyException, with: :forbidden
    rescue_from NoMethodError, with: :not_method_error
    rescue_from ArgumentError, with: :argument_error
    rescue_from ActiveRecord::RecordNotUnique, with: :not_found
    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
      render json: { success: false, message: "Required parameter missing: #{parameter_missing_exception.param}" }, status: :bad_request
    end
  end

  private

  def not_method_error(invalid)
    render json: { success: false, message: invalid.to_s }, status: 500
  end

  def not_found(invalid)
    render json: { success: false, code: 404, message: invalid.to_s }, status: :not_found
  end

  def record_invalid(invalid)
    render json: {success: false, message: invalid.record.errors.messages }, status: :unprocessable_entity
  end

  def argument_error(invalid)
    render json: {success: false, message: invalid.to_s }, status: :unprocessable_entity
  end

  def forbidden
    render json: {success: false, message: 'Forbidden' }, status: 403
  end

  def authorized_app
    raise PolicyException unless request.headers['secret-api'].eql?(ENV['SECRET_API'])
  end
end