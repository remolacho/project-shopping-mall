# == Schema Information
#
# Table name: bill_store_order_items
#
#  id            :bigint           not null, primary key
#  quantity      :integer          not null
#  seller_income :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  bill_store_id :bigint           not null
#  order_item_id :bigint           not null
#
# Indexes
#
#  index_bill_store_order_items_on_bill_store_id  (bill_store_id)
#  index_bill_store_order_items_on_order_item_id  (order_item_id)
#
class BillStoreOrderItem < ApplicationRecord
  belongs_to :bill_store
  belongs_to :order_item
end
