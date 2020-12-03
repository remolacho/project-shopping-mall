# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  complementary_info     :json
#  create_by              :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string
#  lastname               :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rut                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :lastname, :email, :rut, :image, :phone
  attribute :address
  attribute :commune

  def image
    rails_blob_url(object.image, disposition: 'attachment', only_path: true) if object.image.attached?
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
