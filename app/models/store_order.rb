# == Schema Information
#
# Table name: store_orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :float            default(0.0)
#  clean_total      :float            default(0.0)
#  delivery_state   :string
#  global_tax_total :float            default(0.0)
#  mail             :string
#  order_number     :string
#  payment_state    :string
#  payment_total    :float            default(0.0)
#  phone            :string
#  shipment_total   :float            default(0.0)
#  special_comments :string
#  state            :string
#  total            :float            default(0.0)
#  user_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_id         :integer
#  store_id         :integer
#
# Indexes
#
#  index_store_orders_on_order_id  (order_id)
#  index_store_orders_on_store_id  (store_id)
#

class StoreOrder < ApplicationRecord
  belongs_to :order
  belongs_to :store
  has_one :user, through: :order
  has_many :order_adjustments, as: :adjustable
  has_many :order_items

  after_create :generate_ticket

  IS_COMPLETED = 'completed'.freeze
  ON_PURCHASE = 'on_purchase'.freeze

  def consolidate_payment_total
    self.payment_total = order_items.map{ |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
    save!
  end

  private

  def generate_ticket
    self.order_number = "ZON-#{id}#{Time.now.strftime('%d')}#{Time.now.strftime('%m')}#{Time.now.strftime('%M')}"
  end

end
