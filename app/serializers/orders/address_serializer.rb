# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  apartment_number :string
#  comment          :string
#  condominium      :string
#  firstname        :string
#  lastname         :string
#  phone            :string
#  street           :string
#  street_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commune_id       :integer
#  store_id         :integer
#  user_id          :integer
#

class Orders::AddressSerializer < ActiveModel::Serializer
  attributes :id,
             :commune_id,
             :condominium,
             :street,
             :street_number,
             :apartment_number,
             :comment,
             :firstname,
             :lastname,
             :phone,
             :latitude,
             :longitude
end
