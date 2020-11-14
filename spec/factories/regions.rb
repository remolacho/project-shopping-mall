# == Schema Information
#
# Table name: regions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :integer
#
# Indexes
#
#  index_regions_on_country_id  (country_id)
#

FactoryBot.define do
  factory :region do
    name { FFaker::Book.title }
    country { country }
  end
end
