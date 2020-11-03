# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :integer
#  completed_at     :datetime
#  delivery_state   :string
#  payment_state    :string
#  payment_total    :integer
#  shipment_total   :integer
#  state            :string
#  tax_total        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  address_id       :integer
#  user_id          :integer
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
class Order < ApplicationRecord
  belongs_to :user
  has_many :store_orders
  has_many :payments
  has_many :order_adjustments, as: :adjustable
end
