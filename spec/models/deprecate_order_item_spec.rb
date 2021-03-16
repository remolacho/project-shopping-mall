# == Schema Information
#
# Table name: deprecate_order_items
#
#  id                 :bigint           not null, primary key
#  item_qty           :integer
#  start_on           :date
#  unit_value         :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer
#  product_variant_id :bigint
#  store_id           :bigint
#  store_order_id     :bigint
#
# Indexes
#
#  index_deprecate_order_items_on_product_variant_id  (product_variant_id)
#  index_deprecate_order_items_on_store_id            (store_id)
#  index_deprecate_order_items_on_store_order_id      (store_order_id)
#
require 'rails_helper'

RSpec.describe DeprecateOrderItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
