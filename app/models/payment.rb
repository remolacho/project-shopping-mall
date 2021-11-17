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

  UNSTARTED = 'unstarted'.freeze
  APPROVED = 'approved'.freeze
  CANCELLED = 'cancelled'.freeze
  REJECTED = 'rejected'.freeze
  IN_PROCESS = 'in_process'.freeze
  REFUNDED = 'refunded'.freeze

  BANK_TRANSFER = 'bank_transfer'.freeze
  DEBIT_CARD = 'debit_card'.freeze
  CREDIT_CARD = 'credit_card'.freeze

  COMMISSION = 1.8921
  COMMISION_CARD = 3.6771

  def self.commission(current_order)
    payment_type = current_order.payments.last.payment_logs['payment_type_id']

    return COMMISION_CARD if payment_type.eql?(CREDIT_CARD)

    COMMISSION
  end

  def self.commission_by_type(payment_type)
    return COMMISION_CARD if payment_type.eql?(CREDIT_CARD)

    COMMISSION
  end
end
