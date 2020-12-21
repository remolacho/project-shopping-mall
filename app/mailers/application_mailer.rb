class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM']
  layout 'mailer'

  private

  def can_send_email?
    !Rails.env.test? || (Rails.env.test? && ENV['SEND_EMAIL'].eql?('true'))
  end
end
