module Users
  class RecoverPassword

    attr_accessor :user

    def initialize(user:)
      @user = user
    end

    def call
      user.generate_password_token!(1.day.from_now)
      UsersMailer.recover_password(user: user).deliver_now!
      { success: true, message: 'Se realizó con éxito la solicitud de cambio'.freeze }
    end
  end
end
