module Users
  class FindOrCreate
    attr_accessor :allowed_params

    def self.perform(allowed_params:)
      scope = allowed_params
      raise ArgumentError, 'El proveedor esta vacio' unless scope[:provider].present?
      raise ArgumentError, 'El uid esta vacio' unless scope[:uid].present?

      user = User.find_by(email: scope[:email], uid: scope[:uid], provider: scope[:provider])
      return user if user.present?

      password = Devise.friendly_token[0, 20]

      user = User.create!(provider: scope[:provider],
                          uid: scope[:uid],
                          email: scope[:email],
                          password: password,
                          password_confirmation: password,
                          name: scope[:name],
                          lastname: scope[:lastname])

      user.add_role :buyer

      user
    end
  end
end
