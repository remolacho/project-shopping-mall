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
#  order_id        :integer
#
# Indexes
#
#  index_order_adjustments_on_adjustable_type_and_adjustable_id  (adjustable_type,adjustable_id)
#  index_order_adjustments_on_order_id                           (order_id)
#
class OrderAdjustment < ApplicationRecord
  belongs_to :adjustable, polymorphic: true
  belongs_to :order
end
