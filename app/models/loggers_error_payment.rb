# == Schema Information
#
# Table name: loggers_error_payments
#
#  id          :bigint           not null, primary key
#  error       :string
#  log         :json
#  message     :string
#  order_token :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  payment_id  :string
#
class LoggersErrorPayment < ApplicationRecord
end
