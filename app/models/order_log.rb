# == Schema Information
#
# Table name: order_logs
#
#  id             :bigint           not null, primary key
#  log            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :bigint
#  store_order_id :bigint
#
# Indexes
#
#  index_order_logs_on_order_id        (order_id)
#  index_order_logs_on_store_order_id  (store_order_id)
#
class OrderLog < ApplicationRecord
  belongs_to :order
  belongs_to :store_order, optional: true
end
