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

FactoryBot.define do
  factory :brand_category do
    category { category }
    brand { brand }
  end
end
