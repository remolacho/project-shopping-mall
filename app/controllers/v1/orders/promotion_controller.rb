class V1::Orders::PromotionController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/:order_token/promotion/apply/:promo_code
  def apply
    service = ::Orders::ApplyPromotion.new(order: order, promotion: promotion)
    result = service.perform

    unless result.class.eql?(Orders::ShoppingCartSerializer)
      render json: result, status: 202
      return
    end

    render json: { success: true, order: result }, status: 200
  end
end
