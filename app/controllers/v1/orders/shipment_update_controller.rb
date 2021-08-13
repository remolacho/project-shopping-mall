

class V1::Orders::ShipmentUpdateController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorized_app
  
  # POST /v1/orders/shipment_update
  def update
    if params[:order_number].present?

      order = Order.find_by(number_ticket: params[:order_number])

      case params[:status_name].downcase
      when "listo para despacho - impreso"
        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'in_shipping_management').call
      when "planta de origen", "en reparto"
        order.update(delivery_state: "En tránsito")
        order.store_orders.where.not(state: "canceled").map do |so|
          so.update(delivery_state: "En tránsito")
        end

        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'in_transit').call
      when "entregado"
        order.update(delivery_state: "Entregado")
        order.store_orders.where.not(state: "canceled").map do |so|
          so.update(delivery_state: "Entregado")
        end
        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        OrderDeliveredMailer.customer(order: order).deliver_now!
        Payment::Whatsapp::Shipment::Customer.new(order: order, call_method: 'delivered').call
      else
        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
      end
      
    end
  
    render :nothing => true
  end

  # POST /v1/orders/pickup_update
  
  def pickup_update
    if params[:order_number].present?
      order = Order.find_by(number_ticket: params[:order_number])
      if order.shipment.shipment_method.shipment_type.eql?(ShipmentMethod::IN_SITE_TYPE)
        order.update(delivery_state: "Entregado")
        order.store_orders.where.not(state: "canceled").map do |so|
          so.update(delivery_state: "Entregado")
        end
        OrderLog.new(order_id: order.id, log: "enviame (#{params[:tracking_number]}): #{params[:status_information]}" ).save
        OrderDeliveredMailer.customer(order: order).deliver_now!
      end
    end
  
    render :nothing => true
  end

end