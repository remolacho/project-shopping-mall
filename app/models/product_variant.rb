# == Schema Information
#
# Table name: product_variants
#
#  id                             :bigint           not null, primary key
#  active                         :boolean
#  current_stock                  :integer          default(0)
#  deleted_at                     :datetime
#  discount_value                 :float
#  height                         :float
#  internal_sku                   :string
#  is_master                      :boolean          default(FALSE)
#  length                         :float
#  name_translations              :hstore
#  price                          :float
#  short_description_translations :hstore
#  sku                            :string
#  weight                         :float
#  width                          :float
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  product_id                     :integer
#
# Indexes
#
#  index_product_variants_on_deleted_at    (deleted_at)
#  index_product_variants_on_internal_sku  (internal_sku)
#  index_product_variants_on_product_id    (product_id)
#  index_product_variants_on_sku           (sku)
#
class ProductVariant < ApplicationRecord
  translates :name, :short_description

  belongs_to :product
  belongs_to :brand, optional: true
  has_many :variant_history_prices
  has_many :order_items
  has_many :stock_movements
  has_many :variant_options_values

  has_many_attached :images
  has_rich_text :description

  after_save :product_reindex

  scope :is_active, -> { where(active: true) }

  public

  def assign_movement_in(quantity)
    stock_movements.create!(quantity: quantity, movement_type: StockMovement::INVENTORY_IN)
  end

  def current_price
    if discount_value.present? && !discount_value.zero? && discount_value < price
      return discount_value
    end

    price
  end

  private

  def product_reindex
    prod_index = Product.find(product_id)
    prod_index.reindex
  end
end
