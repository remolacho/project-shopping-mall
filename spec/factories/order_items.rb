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
FactoryBot.define do
  factory :order_item do
    item_qty { 1 }
    unit_value { product_variant.price }
    order { order }
    product_variant { product_variant }
    store { store }
    store_order { nil }
  end
end
