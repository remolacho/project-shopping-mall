# frozen_string_literal: true

class Payment::Notify::Stores::Stock
  attr_accessor :payment, :stores_items

  def initialize(payment:, stores_items:)
    @payment = payment
    @stores_items = stores_items
  end

  def call
    stores_items.each do |store_id, items|
      product_variants_ids = items.map(&:product_variant_id)
      product_variants = ProductVariant.where(id: product_variants_ids, current_stock: 0)
      next unless product_variants.present?

      store = Store.find_by(id: store_id)
      next unless store.present?

      target = store.company.user
      next unless target.present?

      product_variants.each do |product_variant|
        options = { data: {
          title: 'Stock en 0',
          content: "La variante #{product_variant.name} se acaba de quedar sin stock, has click en esta notificación para ver más detalles",
          store_id: store.id,
          product_variant_id: product_variant.id },
          sent_at: Time.current,
          event_type: Notification::WARNING,
          segment_type: Notification::SELLER_STOCK,
          token: Notification.generate_token,
        }

        target.notify(options)
      end
    end
  rescue StandardError => e
    logger_error("error al enviar notificacion del stock 0 #{e.to_s}")
  end

  private

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: "#{message || payment.message} - Email store",
      error: payment.status,
      number_ticket: payment.order.number_ticket,
      log: payment.response
    )
  end
end
