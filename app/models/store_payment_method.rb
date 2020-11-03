# == Schema Information
#
# Table name: store_payment_methods
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :integer
#  store_id          :integer
#
# Indexes
#
#  index_store_payment_methods_on_payment_method_id  (payment_method_id)
#  index_store_payment_methods_on_store_id           (store_id)
#
class StorePaymentMethod < ApplicationRecord
  belongs_to :store
  belongs_to :payment_method
end
