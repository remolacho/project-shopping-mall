# == Schema Information
#
# Table name: brands
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_brands_on_name  (name)
#

FactoryBot.define do
	 factory :brand do
 		 name = FFaker::Book.title
 		name { name }
 		slug { name.str_slug }
 	end
end