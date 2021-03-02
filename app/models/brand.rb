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
class Brand < ApplicationRecord
	include Querytable

	has_many :products
	has_many :brand_categories
	has_many :categories, through: :brand_categories
end
