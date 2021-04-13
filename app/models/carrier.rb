# == Schema Information
#
# Table name: carriers
#
#  id         :bigint           not null, primary key
#  name       :string
#  reference  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_carriers_on_name       (name)
#  index_carriers_on_reference  (reference)
#
class Carrier < ApplicationRecord
  has_many :shipment_costs
  has_many :shipments
end
