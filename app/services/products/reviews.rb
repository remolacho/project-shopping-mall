# frozen_string_literal: true

module Products
  class Reviews
    attr_accessor :product

    def initialize(product:)
      @product = product
    end

    def perform
      {
        average: product.rating,
        total_rating: total_rating,
        monitoring_rating: monitoring_rating,
      }
    end

    private

    def monitoring_rating
      rating_group.map do |review|
        {
          label: review.score.to_i.to_s,
          total: review.total,
          percentage: ((review.total.to_f * 100) / total_rating.to_f).to_f.floor(2)
        }
      end
    end

    def total_rating
      @total_rating ||= rating_group.map(&:total).inject(&:+) || 0
    end

    def rating_group
      @rating_group ||= @product.reviews.select('score, COUNT(score) total').group(:score).order(score: :desc)
    end
  end
end
