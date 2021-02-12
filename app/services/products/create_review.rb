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
                              score: data[:score],
                              user_id: find_user)
    end

    private

    def valid_score?
      return if data[:score].to_i.zero?

      data[:score]
    end

    def find_user
      return unless order.user_data.present?
      return unless order.user_data['email'].present?

      user = User.find_by(email: order.user_data['email'])
      return unless user.present?

      user.id
    end
  end
end
