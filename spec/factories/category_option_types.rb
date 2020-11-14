# == Schema Information
#
# Table name: category_option_types
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  option_type_id :bigint
#
# Indexes
#
#  index_category_option_types_on_category_id     (category_id)
#  index_category_option_types_on_option_type_id  (option_type_id)
#

FactoryBot.define do
  factory :category_option_type do
    category { category }
    option_type { option_type }
  end
end