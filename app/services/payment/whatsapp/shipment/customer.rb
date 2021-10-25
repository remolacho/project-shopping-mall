# frozen_string_literal: true

class Payment::Whatsapp::Shipment::Customer
  attr_accessor :order, :call_method

  def initialize(order:, call_method:)
    @order = order
    @call_method = call_method
  end

  def call
    return unless order.user_data.present?
    return unless order.user_data['phone'].present?

    phone = get_phone(order.user_data)
    message = send(call_method)

    HTTParty.post(ENV['WHATSAPP_URI'],
                  body: {
                    phone: phone,
                    body: message,
                  }, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  rescue StandardError
  end

  private

  def get_phone(user_data)
    return "#{ENV['CODE_PHONE']}#{ENV['NUMBER_WHATSAPP'].gsub('-', '').gsub(' ', '')}" unless Rails.env.production?

    "#{ENV['CODE_PHONE']}#{user_data['phone'].gsub('-', '').gsub(' ', '')}"
  end

  def in_shipping_management
    msg = "¡Hola! 👋🏼 Tu pedido #{order.number_ticket} ya está listo para ser despachado. Puedes revisar el estado de tu envío en este link: https://api.enviame.io/s2/companies/3535/deliveries/#{order.number_ticket}/tracking"
    msg
  end

  def in_transit
    "¡Tenemos buenas noticias!  🎉  El despachador ya retiró tu pedido #{order.number_ticket} por lo que pronto lo recibirás en la puerta de tu casa"
  end

  def delivered
    msg = "¡Tu pedido #{order.number_ticket} fue entregado con éxito! 🚚 Gracias por confiar en nosotros, esperamos disfrutes tu compra "
    msg += "y te esperamos nuevamente en Zofrishop.cl"
    msg
  end
end
