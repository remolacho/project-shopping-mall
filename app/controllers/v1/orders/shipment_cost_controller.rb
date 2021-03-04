class V1::Orders::ShipmentCostController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/shipmentCost/:order_token
  def show
    render json: { success: true, shipmentCost: shipment_cost }, status: 200
  end

  def shipment_cost
    total_weight ||= order.total_weight.ceil.clamp(0, 50)
    if total_weight <= 20 && commune.name == "Iquique"
      @shipment_cost = 2990
    else
      @shipment_cost = ShipmentCost.find_by(commune_id: commune.id, weight: total_weight).try(:cost)
    end
    order.update(shipment_total: @shipment_cost)
    order.consolidate_payment_total
    return @shipment_cost
  end

  def commune
    @commune ||= Commune.find(params[:commune_id])
  end

end