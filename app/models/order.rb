# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :float            default(0.0)
#  completed_at     :datetime
#  delivery_state   :string
#  number_ticket    :string
#  payment_state    :string
#  payment_total    :float            default(0.0)
#  shipment_total   :float            default(0.0)
#  state            :string
#  tax_total        :float            default(0.0)
#  token            :string
#  user_data        :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  address_id       :integer
#  user_id          :integer
#
# Indexes
#
#  index_orders_on_number_ticket  (number_ticket) UNIQUE
#  index_orders_on_token          (token) UNIQUE
#  index_orders_on_user_id        (user_id)
#
class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  has_many :store_orders
  has_many :payments
  has_many :order_adjustments, as: :adjustable
  has_many :order_items

  before_create :generate_token
  before_create :on_purchase
  after_create :generate_ticket

  ON_PURCHASE = 'on_purchase'.freeze
  IS_COMPLETED = 'completed'.freeze
  UNSTARTED = 'unstarted'.freeze

  def consolidate_payment_total
    self.payment_total = order_items.map{ |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
    save!
  end

  private

  def generate_token
    self.token = Digest::MD5.hexdigest("Zofr12020Et1n3R#{Time.now.strftime('%d%m%Y%H%M%S')}-#{alternative}")
  end

  def generate_ticket
    self.number_ticket = "ZNT-#{id}#{Time.now.strftime('%d')}#{Time.now.strftime('%m')}#{Time.now.strftime('%M')}"
  end

  def on_purchase
    self.state = ON_PURCHASE
  end

  def alternative
    (Time.now.to_f * 1000.0).to_i
  end
end
