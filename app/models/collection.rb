# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  name       :string
#  slug       :string
#  start_date :datetime
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Collection < ApplicationRecord
  has_many :collection_products
  has_many :products, through: :collection_products

  STATUS_ACTIVE = 'active'.freeze
  STATUS_INACTIVE = 'inactive'.freeze
end
