# == Schema Information
#
# Table name: product_variants
#
#  id                             :bigint           not null, primary key
#  active                         :boolean
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

  validates_presence_of %i[sku internal_sku product_id weight width length height],  message: "es un campo obligatorio"
  validates_uniqueness_of %i[sku internal_sku], message: "ya esta registrado"
  validates_numericality_of %i[weight width length height], :greater_than_or_equal_to => 0, message: "Debe ser numerico"
  validates_numericality_of %i[price discount_value], allow_blank: true, message: "Debe ser numerico"

  after_save :assign_history_price

  scope :is_active, -> { where(active: true) }

  public def assign_movement_in(quantity)
    stock_movements.create!(quantity: quantity, movement_type: StockMovement::INVENTORY_IN)
  end

  private def assign_history_price
    variant_history_prices.find_or_create_by!(value: self.price, discount_value: self.discount_value)
  end
end
