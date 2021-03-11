# frozen_string_literal: true

module GroupTitles
  class ListProducts
    include ::ProductsFiltersV2

    attr_accessor :group_title, :data, :category

    def initialize(group_title:, data:)
      @category = nil
      @data = data
      @group_title = group_title
    end

    def perform
      products_group = group_list
      products_group = filter_by_category(products_group, false)
      products_group = filter_brand(products_group)
      products_group = filter_rating(products_group)
      products_group = filter_prices(products_group)
      products_group = pagination(products_group)

      {
        success: true,
        per_page: ENV['PER_PAGE'].to_i,
        total_pages: products_group.total_pages,
        total_objects: products_group.total_count,
        current_page: (data[:page] || 1).to_i,
        category: ::Categories::GroupTitleSerializer.new(group_title),
        products: serializer(products_group)
      }
    end

    private

    # Overrides method of concerns
    def hierarchy
      categories = group_title.categories.uniq
      raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?

      categories.map(&:id) | categories.map(&:descendant_ids).flatten
    end
  end
end
