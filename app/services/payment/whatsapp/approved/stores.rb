# frozen_string_literal: true

class Payment::Whatsapp::Approved::Stores
  attr_accessor :payment, :order_stores

  def initialize(payment:, order_items:)
    @payment = payment
    @order_stores = order_items
  end

  def call
    pools = []
    group_store = order_stores.group_by(&:store_order_id)
    group_store.each do |_, order_stores|
      store_order = order_stores[0].store_order
      message = get_message(store_order)
      phone = get_phone(store_order)

      next unless message.present?
      next unless phone.present?

      pools << Thread.new do
        HTTParty.post(ENV['WHATSAPP_URI'],
                      body: {
                        phone: phone,
                        body: message,
                      }, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
      end
    end

    pools.map(&:join)
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s}")
  end

  private

  def get_phone(store_order)
    unless Rails.env.production?
      phone = ENV['NUMBER_WHATSAPP'].gsub('-', '').gsub(' ', '')
      return "#{ENV['CODE_PHONE']}#{phone}"
    end

    phone = store_order.store.contact_phone.gsub('-', '').gsub(' ', '')

    "#{ENV['CODE_PHONE']}#{phone}"
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s} attributes: #{store_order.attributes}")
    nil
  end

  def get_message(store_order)
    "¡Hola #{store_order.store.name}!\nHas recibido una nueva compra en Zofrishop 📦 El número de orden es #{store_order.order_number} y puedes revisar el detalle acá: \n https://store-owner.zofrishop.cl/store_owners/stores/#{store_order.store.id}/orders/#{store_order.id} "
  rescue StandardError => e
    logger_error("error al enviar whatsapp: #{e.to_s} attributes: #{store_order.attributes}")
    nil
  end
end
