class Users::ProfileController < ApplicationController
  def me
    render json: {success: true, user: UserSerializer.new(current_user)}, status: 200
  end
end
