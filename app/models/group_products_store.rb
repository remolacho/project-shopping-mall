# == Schema Information
#
# Table name: group_products_stores
#
#  id           :bigint           not null, primary key
#  file_name    :string
#  observations :string
#  status       :integer          default(2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  store_id     :bigint
#
# Indexes
#
#  index_group_products_stores_on_store_id  (store_id)
#
class GroupProductsStore < ApplicationRecord
  belongs_to :store
  has_many :products
  has_many :product_variants, through: :products
end
