

class V1::Orders::ShipmentUpdateController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorized_app
  
  # POST /v1/orders/shipment_update
  def update
    if params[:order_number].present?
      order = Order.find_by(number_ticket: params[:order_number])
      order.update(delivery_state: params[:status_name])
      OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
      OrderDeliveredMailer.customer(order: order).deliver_now! if params[:status_name] == "Entregado"
    end
  
    render :nothing => true
  end

end