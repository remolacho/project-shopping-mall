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

FactoryBot.define do
  factory :address do
    apartment_number { FFaker::Address.building_number }
    condominium { FFaker::Address.street_suffix }
    firstname { FFaker::Address.street_suffix }
    lastname {  FFaker::Address.street_suffix }
    phone { "#{rand(5)}#{rand(5)}#{rand(5)}-#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}" }
    street { FFaker::Address.street_name }
    street_number { FFaker::Address.building_number }
    commune { commune }
  end

  trait :has_user do
    user { user }
  end

  trait :with_store do
    store { store }
  end
end
