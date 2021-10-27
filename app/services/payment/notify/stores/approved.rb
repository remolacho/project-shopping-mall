# frozen_string_literal: true

class Payment::Notify::Stores::Approved
  attr_accessor :payment, :order_stores

  def initialize(payment:, order_items:)
    @payment = payment
    @order_stores = order_items
  end

  def call
    group_store = order_stores.group_by(&:store_order_id)
    group_store.each do |_, order_stores|
      store_order = order_stores[0].store_order
      store = store_order.store
      next unless store.present?

      target = store.company.user
      next unless target.present?

      options = {
        data: {
          title: 'Venta aprobada',
          content: create_message(store_order, store),
          store_id: store.id,
          store_order_id: store_order.id
        },
        sent_at: Time.current,
        event_type: Notification::SUCCESS,
        segment_type: Notification::SELLER,
        token: Notification.generate_token,
      }

      target.notify(options)
    end
  rescue StandardError => e
    logger_error("error al enviar notificacion del stock 0 #{e.to_s}")
  end

  private

  def create_message(store_order,store)
    msg = "¡Hola #{store.name}!\nHas recibido una nueva compra en Zofrishop 📦 El número de orden es #{store_order.order_number}"
    msg += " y puedes revisar el detalle acá: \n https://store-owner.zofrishop.cl/store_owners/stores/#{store.id}/orders/#{store_order.id}"
    msg
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s} attributes: #{store_order.attributes}")
    nil
  end

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: "#{message || payment.message} - notufy seller",
      error: payment.status,
      number_ticket: payment.order.number_ticket,
      log: payment.response
    )
  end
end

