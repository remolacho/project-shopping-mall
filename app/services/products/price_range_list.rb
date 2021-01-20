# frozen_string_literal: true
module Products
  class PriceRangeList

    attr_accessor :data, :category, :store

    def initialize(category: nil, store: nil, data: {})
      @data = data
      @store = store
      @category = category
    end

    def perform; end
  end
end
