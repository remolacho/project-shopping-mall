# == Schema Information
#
# Table name: bill_stores
#
#  id              :bigint           not null, primary key
#  ticket_date     :date             not null
#  ticket_number   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  store_id        :bigint           not null
#  store_module_id :bigint           not null
#
# Indexes
#
#  index_bill_stores_on_store_id         (store_id)
#  index_bill_stores_on_store_module_id  (store_module_id)
#
FactoryBot.define do
  factory :bill_store do
    
  end
end
