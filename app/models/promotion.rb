# == Schema Information
#
# Table name: promotions
#
#  id              :bigint           not null, primary key
#  expires_at      :datetime
#  name            :json
#  promo_code      :string
#  promotion_type  :string
#  promotion_value :float
#  rules           :string
#  starts_at       :datetime
#  usage_limit     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_promotions_on_promo_code  (promo_code) UNIQUE
#
class Promotion < ApplicationRecord
  AMOUNT_PLANE = 'amount_plain'.freeze
  PERCENTAGE = 'percentage'.freeze

  has_many :order_adjustments, as: :adjustable

  validates_inclusion_of :promotion_type, in: [AMOUNT_PLANE, PERCENTAGE]

  def total_usage
    order_adjustments.joins(:order)
        .where(orders: { state: Order::IS_COMPLETED })
        .count
  end
end
