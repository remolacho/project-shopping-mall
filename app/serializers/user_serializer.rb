# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthdate              :date
#  complementary_info     :json
#  create_by              :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :string
#  jti                    :string
#  lastname               :string
#  name                   :string
#  provider               :string           default("zofri")
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rut                    :string
#  uid                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_gender                (gender)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid) UNIQUE
#
class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :lastname, :email, :rut, :image, :phone, :gender, :birthdate
  attribute :address
  attribute :commune

  def image
    polymorphic_url(object.image, host: "zofri-dev.etiner.com") if object.image.attached?
  end

  def address
    return {} unless obj_address.present?

    ::Orders::AddressSerializer.new(obj_address)
  end

  def phone
    return '' unless obj_address.present?

    obj_address.phone
  end

  def commune
    return {} unless obj_commune.present?

    { id: obj_commune.id, name: obj_commune.name }
  end

  def obj_address
    @my_address ||= object.address
  end

  def obj_commune
    return '' unless obj_address.present?

    @obj_commune ||= obj_address.commune
  end
end
