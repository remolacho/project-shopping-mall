# == Schema Information
#
# Table name: shipment_costs
#
#  id         :bigint           not null, primary key
#  cost       :float
#  weight     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  carrier_id :integer
#  commune_id :bigint           not null
#
# Indexes
#
#  index_shipment_costs_on_commune_id  (commune_id)
#  index_shipment_costs_on_weight      (weight)
#
class ShipmentCost < ApplicationRecord
  belongs_to :commune
  belongs_to :carrier
end
