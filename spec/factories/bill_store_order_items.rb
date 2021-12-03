# == Schema Information
#
# Table name: bill_store_order_items
#
#  id                          :bigint           not null, primary key
#  mp_commission_percentage    :float            default(0.0), not null
#  quantity                    :integer          not null
#  seller_income               :float            default(0.0)
#  zofri_commission_percentage :float            default(0.0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  bill_store_id               :bigint           not null
#  order_item_id               :bigint           not null
#
# Indexes
#
#  index_bill_store_order_items_on_bill_store_id  (bill_store_id)
#  index_bill_store_order_items_on_order_item_id  (order_item_id)
#
FactoryBot.define do
  factory :bill_store_order_item do
    
  end
end
