# == Schema Information
#
# Table name: variant_history_prices
#
#  id                 :bigint           not null, primary key
#  discount_value     :float
#  value              :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_variant_id :integer
#
# Indexes
#
#  index_variant_history_prices_on_product_variant_id  (product_variant_id)
#
class VariantHistoryPrice < ApplicationRecord
	belongs_to :product_variant

	validates_numericality_of :value, message: "Debe ser numerico"
	validates_numericality_of :discount_value, allow_blank: true, message: "Debe ser numerico"
end
