# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  name       :string
#  slug       :string
#  start_date :datetime
#  status     :string           default("inactive")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Collection < ApplicationRecord
  has_many :collection_products
  has_many :products, through: :collection_products

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..3.megabytes }

  STATUS_ACTIVE = 'active'.freeze
  STATUS_INACTIVE = 'inactive'.freeze
end
