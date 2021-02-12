# frozen_string_literal: true
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
#  user_id    :integer
#
# Indexes
#
#  index_reviews_on_order_id                 (order_id)
#  index_reviews_on_order_id_and_product_id  (order_id,product_id) UNIQUE
#  index_reviews_on_product_id               (product_id)
#
class Review < ApplicationRecord

  belongs_to :product
  belongs_to :order
  belongs_to :user, optional: true

  after_create :consolidate_rating

  private

  def consolidate_rating
    rating = Review.where(product_id: product_id).average(:score).to_f.round(2)
    product.update!(rating: rating)
  end
end
