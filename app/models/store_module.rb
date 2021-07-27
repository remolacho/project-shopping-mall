# == Schema Information
#
# Table name: store_modules
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  num_module :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint           not null
#
# Indexes
#
#  index_store_modules_on_store_id  (store_id)
#
class StoreModule < ApplicationRecord
  belongs_to :store
  has_many :bill_stores, dependent: :destroy
end
