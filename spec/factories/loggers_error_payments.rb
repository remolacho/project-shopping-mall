# == Schema Information
#
# Table name: loggers_error_payments
#
#  id            :bigint           not null, primary key
#  error         :string
#  log           :json
#  message       :string
#  number_ticket :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  payment_id    :string
#
FactoryBot.define do
  factory :loggers_error_payment do
    
  end
end
