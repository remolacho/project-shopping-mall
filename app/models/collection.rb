# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  end_date   :date
#  name       :string
#  slug       :string
#  start_date :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Collection < ApplicationRecord
  has_many :collection_products
  has_many :products, through: :collection_products
end
