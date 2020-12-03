class Product
  module Querytable
    extend ActiveSupport::Concern

    included do
      def self.counter_categories(limit: 5)
        select('categories.id, categories.name as category_name, categories.slug, COUNT(categories.id) AS total')
            .joins(:category)
            .group('categories.id')
            .order('total DESC')
            .limit(limit)
      end
    end

  end
end
