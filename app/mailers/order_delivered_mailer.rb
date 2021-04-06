class OrderDeliveredMailer < ApplicationMailer
  def customer(order:)
    return unless can_send_email?

    @has_error = false
    @order = order
    @shipment = @order.shipment
    @products = list(@order.order_items)
    @email_to = Rails.env.production? ? @order.user_data['email'] : ENV['EMAIL_TO']
    mail(to: @email_to, subject: 'Entrega exitosa!!!'.freeze)
  rescue StandardError => e
    @has_error = true
    @message = e.to_s
    mail(to: ENV['EMAIL_TO'], subject: 'Error email review'.freeze)
  end

  private

  def list(order_items)
    order_items.map do |item|
      {
        id: item.product_variant.id,
        name: item.product_variant.name,
        quantity: item.item_qty,
        image_url: image_url(item)
      }
    end
  end

  def image_url(order_item)
    image = order_item.product_variant.product.image
    return unless image.present?

    polymorphic_url(image, host: ENV['HOST_IMAGES'])
  end
  
end
