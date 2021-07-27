

class V1::Orders::ShipmentUpdateController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorized_app
  
  # POST /v1/orders/shipment_update
  def update
    if params[:order_number].present?

      order = Order.find_by(number_ticket: params[:order_number])

      case params[:status_name]
      when "Listo para despacho - Impreso"
        order.update(delivery_state: "Listo para retiro")
        order.store_orders.map do |so|
          so.update(delivery_state: "En gestión de envío")
        end

        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'in_shipping_management').call
      when "Planta de origen", "En reparto"
        order.update(delivery_state: "En tránsito")
        order.store_orders.map do |so|
          so.update(delivery_state: "En tránsito")
        end

        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'in_transit').call
      when "Entregado"
        order.update(delivery_state: "Entregado")
        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        OrderDeliveredMailer.customer(order: order).deliver_now!
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'delivered').call
      end
      
    end
  
    render :nothing => true
  end

end