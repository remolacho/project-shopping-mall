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
#  latitude         :float
#  longitude        :float
#  phone            :string
#  street           :string
#  street_number    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commune_id       :integer
#  store_id         :integer
#  user_id          :integer
#
# Indexes
#
#  index_addresses_on_commune_id  (commune_id)
#  index_addresses_on_store_id    (store_id)
#  index_addresses_on_user_id     (user_id)
#
class Address < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :user, optional: true
  belongs_to :commune, optional: true
  has_one :order
end
