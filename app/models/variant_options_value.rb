# == Schema Information
#
# Table name: variant_options_values
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  option_type_id     :integer
#  option_value_id    :integer
#  product_variant_id :integer
#
# Indexes
#
#  index_variant_options_values_on_option_value_id     (option_value_id)
#  index_variant_options_values_on_product_variant_id  (product_variant_id)
#
class VariantOptionsValue < ApplicationRecord
	 belongs_to :product_variant
	 belongs_to :option_value
	 belongs_to :option_type
	 has_one :product, through: :product_variant
end
