class User
  module Recoverable
    extend ActiveSupport::Concern

    def generate_password_token!(expired)
      begin
        self.reset_password_token = SecureRandom.urlsafe_base64
      end while User.exists?(reset_password_token: reset_password_token)
      self.reset_password_token_expires_at = expired
      save!
    end

    def clear_password_token!(password, password_confirmation)
      self.password = password
      self.password_confirmation = password_confirmation
      self.reset_password_token = nil
      self.reset_password_token_expires_at = nil
      save!
    end
  end
end
