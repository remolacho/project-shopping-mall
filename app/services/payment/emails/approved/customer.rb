# frozen_string_literal: true

class Payment::Emails::Approved::Customer
  attr_accessor :payment, :order_items

  def initialize(payment:, order_items:)
    @payment = payment
    @order_items = order_items
  end

  def call
    raise StandardError, 'El cliente no tiene data en la orden' unless payment.order.user_data['email'].present?

    ApprovedPayMailer.customer(to: payment.order.user_data['email'],
                               meta_data: meta_data).deliver_later
  rescue StandardError => e
    logger_error("error al enviar email compra exitosa al cliente: #{e.to_s}")
  end

  private

  def meta_data
    {
      number_ticket: payment.order.number_ticket,
      token: payment.order.token,
      total: payment.order.payment_total,
      shipment: payment.order.shipment_total,
      in_site: payment.order.shipment.shipment_method.shipment_type.eql?(ShipmentMethod::IN_SITE_TYPE),
      products: order_items.map do |item|
        product_variant = item.product_variant
        next unless product_variant.present?

        {
          name: product_variant.name,
          price: item.unit_value,
          quantity: item.item_qty
        }
      end
    }.merge!(payment.order.user_data.deep_symbolize_keys)
  end

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: "#{message || payment.message} - EP customer",
      error: payment.status,
      number_ticket: payment.order.number_ticket,
      log: payment.response
    )
  end
end
