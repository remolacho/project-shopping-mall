# frozen_string_literal: true
# == Schema Information
#
# Table name: group_products_stores
#
#  id         :bigint           not null, primary key
#  file_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint
#
# Indexes
#
#  index_group_products_stores_on_store_id  (store_id)
#
class GroupProductsStore < ApplicationRecord
  belongs_to :store
  has_many :products
  has_many :product_variants, through: :products

  enum status: %i[unstarted in_progress completed canceled]
end
