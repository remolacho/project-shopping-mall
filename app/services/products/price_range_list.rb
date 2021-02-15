# frozen_string_literal: true

module Products
  class PriceRangeList
    attr_accessor :data, :type, :id

    def initialize(type:, id:, data: {})
      @type = type
      @id = id
      @data = data
    end

    def perform
      prices = list.map(&:price)
      return [] unless prices.present?

      to_json(prices.each_slice(per_segment(prices.size)).to_a)
    end

    private

    def list
      case type
      when "category"
        Product.list_prices.where(category_id: hierarchy)
      when "store"
        store.products.is_featured(false).list_prices
      when "group"
        Product.list_prices.where(category_id: hierarchy_titles)
      else
        Product.list_prices.where(category_id: hierarchy)
      end
    end

    def store
      Store.find(id)
    end

    def category
      category = Category.find(id)
    end

    def group_title
      GroupTitle.find(id)
    end
    

    def hierarchy
      [category.id] | category.descendant_ids
    end

    def hierarchy_titles
      categories = group_title.categories
      raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?

      categories.map(&:id) | categories.map(&:descendant_ids).flatten
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
