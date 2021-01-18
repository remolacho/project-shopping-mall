# == Schema Information
#
# Table name: repository_products
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(FALSE)
#  brand       :string
#  code        :string
#  name        :json
#  side_code   :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_repository_products_on_category_id  (category_id)
#
class RepositoryProduct < ApplicationRecord
  include AlgoliaSearch

  belongs_to :category
end
