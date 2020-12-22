class V1::Orders::PromotionController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/:order_token/promotion/apply/:promo_code
  def apply
    service = ::Orders::ApplyPromotion.new(order: order, promotion: promotion)
    render json: { success: true, order: service.perform }, status: 200
  end
end
