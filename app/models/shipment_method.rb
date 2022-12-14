# == Schema Information
#
# Table name: shipment_methods
#
#  id                 :bigint           not null, primary key
#  calculator_formula :string
#  description        :string
#  discount_forumla   :string
#  name               :string
#  shipment_type      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class ShipmentMethod < ApplicationRecord
  has_many :shipments

  IN_SITE_TYPE = 'in_site'.freeze
  DELIVERY_TYPE = 'delivery'.freeze

  validates_inclusion_of :shipment_type, in: [IN_SITE_TYPE, DELIVERY_TYPE]
end
