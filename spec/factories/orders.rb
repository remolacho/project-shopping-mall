# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :float            default(0.0)
#  completed_at     :datetime
#  delivery_state   :string
#  number_ticket    :string
#  payment_state    :string
#  payment_total    :float            default(0.0)
#  shipment_total   :float            default(0.0)
#  state            :string
#  tax_total        :float            default(0.0)
#  token            :string
#  user_data        :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  address_id       :integer
#  user_id          :integer
#
# Indexes
#
#  index_orders_on_number_ticket  (number_ticket) UNIQUE
#  index_orders_on_token          (token) UNIQUE
#  index_orders_on_user_id        (user_id)
#

FactoryBot.define do
  factory :order do
    state { 'on_purchase' }
    delivery_state { 'unstarted' }
    payment_state  { 'unstarted' }
    payment_total  { 0 }
    shipment_total { 0 }
    tax_total      { 0 }
    adjustment_total { 0 }
    address { nil }
    user { nil }
  end

  trait :with_user do
    user { user }
  end

  trait :with_address do
    address { FactoryBot.create(:address, commune: Commune.last) }
  end

  trait :is_completed do
    state { 'completed' }
    completed_at { Time.now }
  end

  trait :with_user_data do
    user_data { user_data }
  end
end

