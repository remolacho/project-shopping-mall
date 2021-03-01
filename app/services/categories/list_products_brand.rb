# frozen_string_literal: true

module Categories
  class ListProductsBrand

    attr_accessor :category

    def initialize(category:)
      @category = category
    end

    def perform
      hierarchy = [category.id] | category.descendant_ids
      Brand.group_products_categories(hierarchy)
    end
  end
end

