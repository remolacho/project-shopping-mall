# == Schema Information
#
# Table name: collection_products
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint           not null
#  product_id    :bigint           not null
#
# Indexes
#
#  index_collection_products_on_collection_id  (collection_id)
#  index_collection_products_on_product_id     (product_id)
#
class CollectionProduct < ApplicationRecord
  belongs_to :product
  belongs_to :collection
end
