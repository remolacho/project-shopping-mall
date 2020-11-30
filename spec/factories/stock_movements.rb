# == Schema Information
#
# Table name: stock_movements
#
#  id                 :bigint           not null, primary key
#  movement_type      :string
#  quantity           :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer
#  product_variant_id :integer
#
# Indexes
#
#  index_stock_movements_on_product_variant_id  (product_variant_id)
#

FactoryBot.define do
  factory :stock_movement do
    movement_type { StockMovement::INVENTORY_IN }
    quantity { quantity }
    product_variant { product_variant }
  end

  trait :inventory_out do
    movement_type { StockMovement::INVENTORY_OUT }
    quantity { quantity }
  end

  trait :with_order do
    order { order }
  end
end

