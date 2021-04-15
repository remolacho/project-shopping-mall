# == Schema Information
#
# Table name: shipments
#
#  id                    :bigint           not null, primary key
#  shipment_method_state :string
#  state                 :string
#  tracking_code         :string
#  value                 :float            default(0.0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  carrier_id            :integer
#  order_id              :integer
#  shipment_method_id    :bigint
#
# Indexes
#
#  index_shipments_on_order_id            (order_id)
#  index_shipments_on_shipment_method_id  (shipment_method_id)
#
class Shipment < ApplicationRecord
  belongs_to :order
  belongs_to :shipment_method, optional: true
  belongs_to :carrier, optional: true

  ACTIVE = 'active'
  INACTIVE = 'inactive'

  UNSTARTED = 'unstarted'.freeze
  IN_PROCESS = 'in_process'.freeze
  PENDING = 'pending'.freeze
  CANCELLED = 'cancelled'.freeze

  after_destroy :consolidate_order

  private

  def consolidate_order
    order.update!(shipment_total: 0, delivery_state: Order::UNSTARTED_DELIVERY)
    order.consolidate_payment_total
  end
end
