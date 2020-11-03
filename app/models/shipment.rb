# == Schema Information
#
# Table name: shipments
#
#  id                    :bigint           not null, primary key
#  shipment_method_state :string
#  state                 :string
#  tracking_code         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  order_adjustment_id   :bigint
#  shipment_method_id    :bigint
#
# Indexes
#
#  index_shipments_on_order_adjustment_id  (order_adjustment_id)
#  index_shipments_on_shipment_method_id   (shipment_method_id)
#
class Shipment < ApplicationRecord
  belongs_to :order_adjustment
  belongs_to :shipment_method
end
