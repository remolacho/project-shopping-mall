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
class StockMovement < ApplicationRecord
  belongs_to :product_variant
  belongs_to :order, optional: true

  INVENTORY_IN = 'inventory in'.freeze
  INVENTORY_OUT = 'inventory out'.freeze

  validates_presence_of %i[movement_type], message: "es un campo obligatorio"
  validates_numericality_of :quantity, message: "Debe ser numerico"

  after_create :consolidate_stock
  after_destroy :consolidate_stock

  private

  def consolidate_stock
    product_variant.current_stock = product_variant.stock_movements.sum(&:quantity)
    product_variant.save!
  end
end
