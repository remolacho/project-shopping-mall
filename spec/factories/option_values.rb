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

FactoryBot.define do
  factory :option_value do
    value { {es: FFaker::Book.title} }
    option_type { option_type }

    before(:create) do |option_value|
      option_value.slug = option_value.value['es'].str_slug
    end
  end
end