# == Schema Information
#
# Table name: store_payment_methods_configurations_values
#
#  id                               :bigint           not null, primary key
#  value                            :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  payment_methods_configuration_id :integer
#  store_payment_method_id          :integer
#
class StorePaymentMethodsConfigurationsValue < ApplicationRecord
  belongs_to :store_payment_method
  belongs_to :payment_methods_configuration
  has_one :store, through: :store_payment_method
end
