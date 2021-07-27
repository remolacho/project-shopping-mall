class Users::PasswordController < ApplicationController
  skip_before_action :authenticate_user!

  respond_to :json

  # POST /users/password/recover
  def recover
    service = Users::RecoverPassword.new(user: user_by_email)
    render json: service.call, status: :ok
  end

  # POST /users/password/change
  def change
    service = Users::ChangePassword.new(user: user_reset_token, data: allowed_params)
    render json: service.call, status: :ok
  end

  private

  def allowed_params
    params[:user].permit!
  end
end
