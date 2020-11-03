# == Schema Information
#
# Table name: brand_categories
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  brand_id    :bigint
#  category_id :bigint
#
# Indexes
#
#  index_brand_categories_on_brand_id     (brand_id)
#  index_brand_categories_on_category_id  (category_id)
#
class BrandCategory < ApplicationRecord
  belongs_to :brand
  belongs_to :category
end
