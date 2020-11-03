# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  code       :string
#  depth      :integer
#  name       :json
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_ancestry  (ancestry)
#
class Category < ApplicationRecord
  has_many :products
  has_many :stores
  has_many :product_variants, through: :products
  has_many :category_option_types
  has_many :option_types, through: :category_option_types
  has_many :brand_categories
  has_many :brands, through: :brand_categories
  has_many :repository_products

  has_ancestry

  def category_hierarchy_names
    ancestors.map{ |c| c.name[I18n.locale.to_s] }.join(' > ')
  end

  def all_category_hierarchy_names
    result = ancestors.map{ |c| c.name[I18n.locale.to_s] }.join(' > ')
    return name[I18n.locale.to_s] unless result.present?

    "#{result} > #{name[I18n.locale.to_s]}"
  end

  def category_hierarchy
    ancestors.map{ |c| {id: c.id, name: c.name[I18n.locale.to_s]} }
  end

end
