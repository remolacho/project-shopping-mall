class ApprovedPayMailer < ApplicationMailer
  def store(to:, meta_data:)
    return unless can_send_email?

    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, bcc: 'zofrishop@gmail.com', subject: '¡Has recibido una compra por ZofriShop! 🎉'.freeze)
  end

  def customer(to:, meta_data:)
    return unless can_send_email?
    @order = Order.find_by(number_ticket: meta_data[:number_ticket])
    attachments["orden_#{@order.number_ticket}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(pdf: 'invoice', template: 'pdf/invoice.pdf.erb'), { footer: {content: render_to_string({template: 'layouts/footer.pdf.erb'})} }
    )
    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, bcc: 'zofrishop@gmail.com', subject: '¡Gracias por comprar en ZofriShop! Estamos preparando tu orden 🚚📦'.freeze)
  end
end
