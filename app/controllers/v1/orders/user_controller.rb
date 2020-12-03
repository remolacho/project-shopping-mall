class V1::Orders::UserController < ApplicationController
  skip_before_action :authenticate_user!

  # POST /v1/orders/:order_token/user
  def create
    service = Orders::AssignUserData.new(order: order, data: allowed_params)
    render json: { success: true, user: service.perform }, status: 200
  end

  private

  def allowed_params
    params.require(:user).permit(:name, :last_name, :email, :phone)
  end

end

