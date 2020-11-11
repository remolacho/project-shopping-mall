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
#  token            :string
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
  belongs_to :user, optional: true
  has_many :store_orders
  has_many :payments
  has_many :order_adjustments, as: :adjustable

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::MD5.hexdigest("Zofr12020Et1n3R#{Time.now.strftime('%d%m%Y%H%M%S')}")
  end
end
