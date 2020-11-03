# == Schema Information
#
# Table name: payment_methods_configurations
#
#  id                :bigint           not null, primary key
#  description       :string
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :integer
#
# Indexes
#
#  index_payment_methods_configurations_on_payment_method_id  (payment_method_id)
#
class PaymentMethodsConfiguration < ApplicationRecord
  belongs_to :payment_method
  has_many :store_payment_methods_configurations_values
end
