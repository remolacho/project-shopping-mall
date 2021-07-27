class UsersMailer < ApplicationMailer
  def recover_password(user:)
    return unless can_send_email?

    @user = user
    @subject = 'Recuperación contraseña'.freeze
    @email_to = Rails.env.production? ? @user.email : ENV['EMAIL_TO']

    mail(to: @email_to, subject: @subject)
  end
end
