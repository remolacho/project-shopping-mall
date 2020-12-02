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

FactoryBot.define do
  factory :shipment_method do
    name { FFaker::Book.title }
    description { FFaker::Book.title }
    shipment_type { shipment_type }
  end
end
