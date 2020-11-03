# == Schema Information
#
# Table name: option_types
#
#  id         :bigint           not null, primary key
#  name       :json
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OptionType < ApplicationRecord
	has_many :option_values
	has_many :category_option_types
	has_many :variant_options_values
	has_many :categories, through: :category_option_types
end
