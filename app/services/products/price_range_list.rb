# frozen_string_literal: true

module Products
  class PriceRangeList
    attr_accessor :data, :category

    def initialize(category:, data: {})
      @data = data
      @category = category
    end

    def perform
      prices = list.map(&:price)
      return [] unless prices.present?

      to_json(prices.each_slice(per_segment(prices.size)).to_a)
    end

    private

    def list
      Product.list_prices.where(category_id: hierarchy)
    end

    def hierarchy
      [category.id] | category.descendant_ids
    end

    def to_json(prices)
      {
        success: true,
        ranges: prices.map { |p| "#{p.first.to_i}-#{p.last.to_i}" }
      }
    end

    def per_segment(prices)
      total_segments = 4
      total_prices = prices.size
      (total_prices / total_segments)
    end
  end
end
