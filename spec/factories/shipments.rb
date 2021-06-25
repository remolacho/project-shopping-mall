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

FactoryBot.define do
  factory :shipment do
    shipment_method_state { Shipment::ACTIVE }
    state { Shipment::IN_PROCESS }
    value { 1000 }
    shipment_method { shipment_method }
  end
end