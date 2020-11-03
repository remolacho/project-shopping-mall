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
class PaymentMethod < ApplicationRecord
  has_many :payments
  has_many :store_payment_methods
end
