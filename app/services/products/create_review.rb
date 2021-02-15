module Products
  class CreateReview
    attr_accessor :order, :data, :product

    def initialize(order:, product:, data:)
      @order = order
      @data = data
      @product = product
    end

    def perform
      raise ArgumentError, 'El score esta vacio' unless valid_score?

      product.reviews.create!(order_id: order.id,
                              comment: data[:comment],
                              score: data[:score])
    end

    private

    def valid_score?
      return if data[:score].to_i.zero?

      data[:score]
    end
  end
end
