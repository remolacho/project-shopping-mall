# frozen_string_literal: true

module Products
  class ListToReview
    attr_accessor :order

    def initialize(order:)
      @order = order
    end

    def perform
      order_items = order.order_items.includes(product_variant: [product: %i[category brand]])
      skip_products_ids = order.reviews.pluck(:product_id)
      order_items.reject { |item| skip_products_ids.include?(item.product_variant.product_id) }
    end
  end
end
