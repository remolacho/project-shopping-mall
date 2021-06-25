# == Schema Information
#
# Table name: carriers
#
#  id         :bigint           not null, primary key
#  name       :string
#  reference  :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_carriers_on_name       (name)
#  index_carriers_on_reference  (reference)
#  index_carriers_on_slug       (slug)
#

FactoryBot.define do
  factory :carrier do
    name = FFaker::Book.title
    name { name }
    slug { name.str_slug }
  end
end
