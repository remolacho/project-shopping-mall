module Users
  class ChangePassword

    attr_accessor :user, :data

    def initialize(user:, data:)
      @user = user
      @data = data
    end

    def call
      user.clear_password_token!(data[:password], data[:password_confirmation])

      {
        success: true,
        message: 'Se cambia con exito la contraseña'.freeze,
        redirect_to: render_to
      }
    end

    private

    def render_to
      return 'zofri-shop'.freeze if !user.roles.present? || user.has_role?(:buyer)

      'store-owner'.freeze
    end
  end
end
