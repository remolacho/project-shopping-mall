# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  completed_at   :datetime
#  delivery_state :string
#  number_ticket  :string
#  payment_state  :string
#  payment_total  :float            default(0.0)
#  shipment_total :float            default(0.0)
#  state          :string
#  tax_total      :float            default(0.0)
#  token          :string
#  user_data      :json
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  address_id     :integer
#  user_id        :integer
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
  has_many :order_adjustments
  has_many :order_items
  has_many :stock_movements
  has_one :shipment
  has_many :product_variants, through: :order_items
  has_many :reviews

  before_create :generate_token
  before_create :on_purchase
  after_create :generate_ticket

  ON_PURCHASE = 'on_purchase'.freeze
  IS_COMPLETED = 'completed'.freeze
  UNSTARTED = 'unstarted'.freeze

  PENDING_DELIVERY = 'Recepción pendiente'.freeze
  UNSTARTED_DELIVERY = 'unstarted'.freeze

  def consolidate_payment_total
    self.payment_total = total_sum_order_items
    self.payment_total += shipment_total.to_f
    self.payment_total += order_adjustments.where(adjustable_type: 'Promotion'.freeze).sum(&:value)
    save!
  end

  def total_sum_order_items
    order_items.map { |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
  end

  def is_completed?
    self.state.eql?(IS_COMPLETED)
  end

  def on_purchase?
    self.state.eql?(ON_PURCHASE)
  end

  def has_promotion?
    !order_adjustments.where(adjustable_type: 'Promotion'.freeze).count.zero?
  end

  def total_weight
    order_items.map { |order_item| order_item.product_variant.weight }.sum
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
