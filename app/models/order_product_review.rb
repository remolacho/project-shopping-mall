# == Schema Information
#
# Table name: order_product_reviews
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  comment    :string           default("0")
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
class OrderProductReview < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product
  belongs_to :order

  after_update :rating_product

  UNSTARTED = 0
  COMPLETED = 1

  scope :unstarted, -> { where(status: UNSTARTED) }
  scope :finished, -> { where(status: FINISHED) }
  scope :is_active, -> { where(active: true) }
  scope :by_product, ->(product_id) {  where(product_id: product_id) }

  private

  def rating_product
    product.rating = OrderProductReview.by_product(product_id)
                                       .finished
                                       .is_active
                                       .average(:rating)
    product.save!
  end

end
