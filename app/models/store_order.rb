# == Schema Information
#
# Table name: store_orders
#
#  id               :bigint           not null, primary key
#  clean_total      :float            default(0.0)
#  delivery_state   :string
#  global_tax_total :float            default(0.0)
#  mail             :string
#  module           :string
#  order_number     :string
#  payment_state    :string
#  payment_total    :float            default(0.0)
#  phone            :string
#  seller_paid_at   :datetime
#  shipment_total   :float            default(0.0)
#  special_comments :string
#  state            :string
#  ticket_date      :date
#  ticket_number    :string
#  total            :float            default(0.0)
#  user_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_id         :integer
#  store_id         :integer
#
# Indexes
#
#  index_store_orders_on_order_id        (order_id)
#  index_store_orders_on_seller_paid_at  (seller_paid_at)
#  index_store_orders_on_store_id        (store_id)
#

class StoreOrder < ApplicationRecord
  belongs_to :order
  belongs_to :store
  has_one :user, through: :order
  has_many :order_items
  has_one :channels_room

  after_create :generate_ticket

  IS_COMPLETED = 'completed'.freeze
  ON_PURCHASE = 'on_purchase'.freeze

  PENDING_DELIVERY = 'Pendiente de entrega'.freeze

  def consolidate_payment_total
    self.payment_total = total_sum_order_items
    save!
  end

  def total_sum_order_items
    order_items.map{ |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
  end

  private

  def generate_ticket
    self.order_number = "ZON-#{id}#{Time.now.strftime('%d')}#{Time.now.strftime('%m')}#{Time.now.strftime('%M')}"
  end

end
