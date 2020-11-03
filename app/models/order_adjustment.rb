# == Schema Information
#
# Table name: order_adjustments
#
#  id              :bigint           not null, primary key
#  adjustable_type :string
#  description     :string
#  value           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  adjustable_id   :bigint
#
# Indexes
#
#  index_order_adjustments_on_adjustable_type_and_adjustable_id  (adjustable_type,adjustable_id)
#
class OrderAdjustment < ApplicationRecord
  belongs_to :adjustable, polymorphic: true
  has_many :shipments
end
