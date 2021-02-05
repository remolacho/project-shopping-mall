# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :string
#  score      :float            default(1.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_order_id                 (order_id)
#  index_reviews_on_order_id_and_product_id  (order_id,product_id) UNIQUE
#  index_reviews_on_product_id               (product_id)
#
FactoryBot.define do
  factory :review do
    score { rand(1..5) }
    comment { FFaker::Book.title }
    order { order }
    product { product }
  end
end
