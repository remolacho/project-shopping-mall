# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :integer
#  completed_at     :datetime
#  delivery_state   :string
#  number_ticket    :string
#  payment_state    :string
#  payment_total    :integer
#  shipment_total   :integer
#  state            :string
#  tax_total        :integer
#  token            :string
#  user_data        :json
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
  has_many :addresses
  has_many :order_items

  before_create :generate_token
  before_create :generate_ticket

  ON_PURCHASE = 'on_purchase'.freeze
  IS_COMPLETED = 'completed'.freeze

  private

  def generate_token
    self.token = Digest::MD5.hexdigest("Zofr12020Et1n3R#{Time.now.strftime('%d%m%Y%H%M%S')}")
  end

  def generate_ticket
    self.token = "ZNT-#{Time.now.strftime('%d%m%Y%H%M%S')}"
  end
end
