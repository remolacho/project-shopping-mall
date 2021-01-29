# frozen_string_literal: true

module Categories
  class ListProducts
    include ::ProductsFilters

    attr_accessor :category, :data

    def initialize(category:, data:)
      @category = category
      @data = data
    end

    def perform
      products_group = group_list
      products_group = filter_by_category(products_group)
      products_group = filter_brand(products_group)
      products_group = filter_rating(products_group)
      products_group = filter_prices(products_group)
      products_group = pagination(products_group)

      {
        success: true,
        per_page: ENV['PER_PAGE'].to_i,
        total_pages: products_group.total_pages,
        total_objects: products_group.total_count,
        category: ::Categories::CategorySerializer.new(category),
        products: serializer(products_group)
      }
    end
  end
end
