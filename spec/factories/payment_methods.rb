# == Schema Information
#
# Table name: payment_methods
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  description :string
#  name        :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :payment_method do
    active { true }
    description { FFaker::Book.title }
    name  { 'Mercado pago' }
    position { 1 }
  end
end
