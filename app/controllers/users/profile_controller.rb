class Users::ProfileController < ApplicationController
  def me
    render json: {success: true, user: UserSerializer.new(current_user)}, status: 200
  end

  def update
    current_user.update!(allowed_params)
    render json: {success: true, user: UserSerializer.new(current_user)}, status: :ok
  end

  private

  def allowed_params
    params.require(:user).permit(:name, :lastname, :rut, :email, :gender, :birthdate)
  end
end
