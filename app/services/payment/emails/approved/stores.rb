# frozen_string_literal: true

class Payment::Emails::Approved::Stores
  attr_accessor :payment, :stores_items

  def initialize(payment:, stores_items:)
    @payment = payment
    @stores_items = stores_items
  end

  def call
    stores = Store.includes(:company).where(id: stores_items.keys)
    stores.each do |store|
      store_order = payment.order.store_orders.find_by(store_id: store.id)
      next unless store_order.present?

      store_items = stores_items[store.id]
      next unless store_items.present?
      next unless store.company.contact_email.present?

      ApprovedPayMailer.store(to: store.company.contact_email,
                              meta_data: meta_data(store, store_order, store_items)).deliver_later
    end
  rescue StandardError => e
    logger_error("error al enviar email compra exitosa a la tienda #{e.to_s}")
  end

  private

  def meta_data(store, store_order, store_items)
    {
      store_name: store.name,
      store_id: store.id,
      store_order_number: store_order.order_number,
      store_order_id: store_order.id,
      number_ticket: payment.order.number_ticket,
      total: store_order.payment_total,
      shipment: store_order.shipment_total,
      products: store_items.map do |item|
        product_variant = item.product_variant
        next unless product_variant.present?

        {
          name: product_variant.name,
          price: item.unit_value,
          quantity: item.item_qty
        }
      end
    }.merge!(user_data: payment.order.user_data.deep_symbolize_keys)
  end

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: "#{message || payment.message} - Email store",
      error: payment.status,
      number_ticket: payment.number_ticket,
      log: payment.response
    )
  end
end
