# frozen_string_literal: true

module GroupTitles
  class ListProductsBrand
    attr_accessor :group_title

    def initialize(group_title:)
      @group_title = group_title
    end

    def perform
      Brand.group_products_categories(hierarchy)
    end

    private

    # Overrides method of concerns
    def hierarchy
      categories = group_title.categories
      raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?

      categories.map(&:id) | categories.map(&:descendant_ids).flatten
    end
  end
end
