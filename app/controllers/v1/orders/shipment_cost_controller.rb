class V1::Orders::ShipmentCostController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/shipmentCost/:order_token
  def show
    render json: { success: true, shipmentCost: shipment_cost }, status: 200
  end

  def shipment_cost
    total_weight ||= order.total_weight.ceil.clamp(0, 50)
    if total_weight <= 20 && commune.name == "Iquique" && total_sum_order_items <= 100000.0
      @shipment_cost = 2990
    else
      @shipment_cost = ShipmentCost.find_by(commune_id: commune.id, weight: total_weight).try(:cost) || ShipmentCost.where(commune_id: commune.id).maximum(:cost)
    end
    order.update(shipment_total: @shipment_cost)
    order.consolidate_payment_total
    return @shipment_cost
  end

  def commune
    @commune ||= Commune.find(params[:commune_id])
  end

  def total_sum_order_items
    order.order_items.map { |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
  end

end