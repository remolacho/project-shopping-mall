class V1::Orders::CompletedController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/completed/8b7f2a6bfd2785f76f1f45373b0f3151
  def show
    service = ShoppingCart::Items.new(user: with_user, order: order_completed)
    render json: service.perform, status: 200
  end
end
