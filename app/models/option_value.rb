# == Schema Information
#
# Table name: option_values
#
#  id             :bigint           not null, primary key
#  slug           :string
#  value          :json
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  option_type_id :integer
#
# Indexes
#
#  index_option_values_on_option_type_id  (option_type_id)
#
class OptionValue < ApplicationRecord
	belongs_to :option_type
	has_many :variant_options_values
end
