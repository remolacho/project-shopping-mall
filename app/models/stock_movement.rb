# == Schema Information
#
# Table name: stock_movements
#
#  id                 :bigint           not null, primary key
#  movement_type      :string
#  quantity           :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_variant_id :integer
#
# Indexes
#
#  index_stock_movements_on_product_variant_id  (product_variant_id)
#
class StockMovement < ApplicationRecord
  belongs_to :product_variant

  INVENTORY_IN = 'inventory in'.freeze
  INVENTORY_OUT = 'inventory out'.freeze

  validates_presence_of %i[movement_type],  message: "es un campo obligatorio"
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0, message: "Debe ser numerico"
end
