# == Schema Information
#
# Table name: stores
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  certifications :string
#  facebook       :string
#  instagram      :string
#  mall_location  :string
#  name           :string
#  sheets_row     :integer
#  twitter        :string
#  website        :string
#  what_we_do     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :integer
#  commune_id     :integer
#  company_id     :integer
#
# Indexes
#
#  index_stores_on_commune_id     (commune_id)
#  index_stores_on_mall_location  (mall_location)
#  index_stores_on_name           (name)
#
class Store < ApplicationRecord
  belongs_to :category
  belongs_to :company
  belongs_to :commune, optional: true
  has_many :addresses
  has_many :promotions
  has_many :order_items
  has_many :products
  has_many :product_variants, through: :products
  has_many :group_products_stores

  has_one :user, through: :company

  has_one_attached :icon
  has_one_attached :banner

  scope :is_active, -> { where(active: true) }
end
