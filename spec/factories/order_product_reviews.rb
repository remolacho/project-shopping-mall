# == Schema Information
#
# Table name: order_product_reviews
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  comment    :string
#  rating     :integer          default(0)
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  product_id :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_order_product_reviews_on_order_id    (order_id)
#  index_order_product_reviews_on_product_id  (product_id)
#  index_order_product_reviews_on_user_id     (user_id)
#
FactoryBot.define do
  factory :order_product_review do
    
  end
end
