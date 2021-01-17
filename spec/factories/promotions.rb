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

FactoryBot.define do
  factory :promotion do
    name { FFaker::Book.title }
    expires_at { (Time.now + 1.day) }
    starts_at { Time.now }
    usage_limit { 1 }
    promo_code { "ZNT-#{rand(1000)}#{Time.now.strftime('%d')}#{Time.now.strftime('%m')}#{Time.now.strftime('%M')}" }
  end

  trait :not_started do
    starts_at { (Time.now + 1.day) }
    expires_at { (Time.now + 2.day) }
  end

  trait :expired do
    starts_at { (Time.now - 1.day) }
    expires_at { (Time.now - 1.day) }
  end

  trait :percentage do
    promotion_type { Promotion::PERCENTAGE }
    promotion_value { 10 }
  end

  trait :amount_plain do
    promotion_type { Promotion::AMOUNT_PLANE }
    promotion_value { 1000 }
  end
end

