# frozen_string_literal: true

module Products
  class Reviewers
    include Rails.application.routes.url_helpers

    attr_accessor :product, :data

    def initialize(product:, data:)
      @product = product
      @data = data
    end

    def perform
      {
        per_page: ENV['PER_PAGE'].to_i,
        total_pages: reviews.total_pages,
        total_objects: reviews.total_count,
        comments: reviewers
      }
    end

    private

    def reviewers
      reviews.map do |review|
        {
          comment: review.comment,
          score: review.score,
          full_name: full_name(review),
          image_url: image_url(review)
        }
      end
    end

    def reviews
      @reviews ||= product.reviews.includes(:order, :user)
                          .order(score: data[:sort] || :desc)
                          .page(data[:num_page] || 1).per(ENV['PER_PAGE'])
    end

    def image_url(review)
      return unless review.user.present?
      return unless review.user.image.attached?

      polymorphic_url(user.image, host: ENV['HOST_IMAGES'])
    end

    def full_name(review)
      return review.user.full_name if review.user.present?
      return 'Guess' unless review.order.user_data.present?

      "#{review.order.user_data[:name]} #{review.order.user_data[:last_name]}"
    end
  end
end
