# == Schema Information
#
# Table name: order_items
#
#  id                 :bigint           not null, primary key
#  item_qty           :integer
#  unit_value         :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer          not null
#  product_variant_id :bigint
#  store_id           :bigint
#  store_order_id     :bigint
#
# Indexes
#
#  index_order_items_on_product_variant_id  (product_variant_id)
#  index_order_items_on_store_id            (store_id)
#  index_order_items_on_store_order_id      (store_order_id)
#
class OrderItem < ApplicationRecord
  belongs_to :product_variant
  belongs_to :store_order, optional: true
  belongs_to :store
  belongs_to :order

  validates :item_qty, numericality: { only_integer: true }, allow_blank: true
  validates_presence_of :item_qty, on: :update
end
