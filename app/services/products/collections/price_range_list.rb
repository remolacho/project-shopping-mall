# frozen_string_literal: true

module Products
  module Collections
    class PriceRangeList
      include ProductsFilters

      attr_accessor :collection, :category

      def initialize(collection:, category:)
        @collection = collection
        @category = category
      end

      def perform
        prices = list.map(&:filter_price)
        return [] unless prices.present?

        to_json(prices.each_slice(per_segment(prices)).to_a)
      end

      private

      def list
        products = collection.products.list_prices
        filter_by_category(products)
      end

      def to_json(prices)
        range = prices.map { |p|
          p = p.compact

          next "#{p.first.to_i}-#{p.last.to_i + 1000}" if p.first.to_i == p.last.to_i

          "#{p.first.to_i}-#{p.last.to_i}"
        }

        { success: true, ranges: range }
      end

      def per_segment(prices)
        total_prices = prices.size
        total_segments = 4

        return 2 if total_prices <= total_segments

        total = (total_prices / total_segments)

        return 1 if total.zero?

        total
      end
    end
  end
end
