# == Schema Information
#
# Table name: payments
#
#  id                :bigint           not null, primary key
#  payment_logs      :json
#  state             :string
#  total             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  order_id          :integer
#  payment_method_id :integer
#
# Indexes
#
#  index_payments_on_order_id           (order_id)
#  index_payments_on_payment_method_id  (payment_method_id)
#
class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_method

  APPROVED = 'approved'.freeze
  CANCELLED = 'cancelled'.freeze
  REJECTED = 'rejected'.freeze
  IN_PROCESS = 'in_process'.freeze
  REFUNDED = 'refunded'.freeze
end
