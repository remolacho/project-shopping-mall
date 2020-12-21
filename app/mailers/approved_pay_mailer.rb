class ApprovedPayMailer < ApplicationMailer
  def store(to:, meta_data:)
    return unless can_send_email?

    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, subject: 'Compra exitosa!!!'.freeze)
  end

  def customer(to:, meta_data:)
    return unless can_send_email?

    @meta_data = meta_data
    @email_to = Rails.env.production? ? to : ENV['EMAIL_TO']
    mail(to: @email_to, subject: 'Compra exitosa!!!'.freeze)
  end
end
