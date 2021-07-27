# frozen_string_literal: true

class Payment::Whatsapp::Approved::Customer
  attr_accessor :payment, :order_stores

  def initialize(payment:, order_items:)
    @payment = payment
    @order_stores = order_items
  end

  def call
    return unless payment.order.user_data.present?
    return unless payment.order.user_data['phone'].present?

    HTTParty.post(ENV['WHATSAPP_URI'],
                  body: {
                    phone: get_phone(payment.order.user_data),
                    body: get_message,
                  }, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  rescue StandardError => e
    logger_error("error al enviar whatsapp customer: #{e.to_s}")
  end

  private

  def get_phone(user_data)
    return "#{ENV['CODE_PHONE']}#{ENV['NUMBER_WHATSAPP'].gsub('-', '').gsub(' ', '')}" unless Rails.env.production?

    "#{ENV['CODE_PHONE']}#{user_data['phone'].gsub('-', '').gsub(' ', '')}"
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s} attributes: #{payment.order.attributes}")
    nil
  end

  def get_message
    msg = "¡Has comprado exitosamente en Zofrishop! Ya estamos preparando tu pedido.Tu número de orden es"
    msg += " <#{payment.order.number_ticket}> y puedes ver el detalle de tu compra en el siguiente"
    msg += " link: #{ENV['BASE_PATH']}/view-order?external_reference=#{payment.order.token}"
    msg
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s} attributes: #{payment.order.attributes}")
    nil
  end

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: "#{message || payment.message} - send whatsapp",
      error: payment.status,
      order_token: payment.order_token,
      log: payment.response
    )
  end
end