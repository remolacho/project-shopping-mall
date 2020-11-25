class V1::Orders::CheckOrderController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/checkOrder/8b7f2a6bfd2785f76f1f45373b0f3151
  def show
    check = ShoppingCart::Check.new(user: with_user, order: order).perform
    render json: check, status: check[:state]
  end
end
