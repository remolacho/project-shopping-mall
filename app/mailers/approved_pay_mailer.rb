class ApprovedPayMailer < ApplicationMailer
  def store(to:, meta_data:)
    return unless can_send_email?

    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, subject: '¡Has recibido una compra por ZofriShop! 🎉'.freeze)
  end

  def customer(to:, meta_data:)
    return unless can_send_email?
    @order = Order.find(number_ticket: meta_data[:number_ticket])
    attachments["orden_#{@order.number_ticket}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: 'invoice', template: 'pdf/invoice.pdf.erb'), { :hash_with_wickedpdf_options }
    )
    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, subject: '¡Gracias por comprar en ZofriShop! Estamos preparando tu orden 🚚📦'.freeze)
  end
end
