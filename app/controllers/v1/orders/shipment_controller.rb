class V1::Orders::ShipmentController < ApplicationController
  skip_before_action :authenticate_user!

  # POST /v1/orders/:order_token/shipment
  def create
    service = Orders::CreateShipment.new(order: order, data: allowed_params)
    render json: { success: true, order: service.perform }, status: 200
  end

  private

  def allowed_params
    params.require(:shipment).permit(:commune_id,
                                     :shipment_id,
                                     :apartment_number,
                                     :condominium,
                                     :street,
                                     :street_number,
                                     :comment,
                                     :firstname,
                                     :lastname,
                                     :delivery_price,
                                     :latitude,
                                     :longitude)
  end
end
