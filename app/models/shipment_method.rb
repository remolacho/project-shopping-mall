# == Schema Information
#
# Table name: shipment_methods
#
#  id                 :bigint           not null, primary key
#  calculator_formula :string
#  description        :string
#  discount_forumla   :string
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class ShipmentMethod < ApplicationRecord
  has_many :shipments
end
