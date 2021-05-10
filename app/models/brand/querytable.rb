class Brand
  module Querytable
    extend ActiveSupport::Concern

    included do
      def self.group_products_categories(hierarchy)
        select('brands.id, brands.name, brands.slug, COUNT(products.id) AS products_count')
          .joins(:products)
          .where(products: { can_published: true, category_id: hierarchy })
          .group('brands.id')
          .order('products_count DESC')
      end

      def self.group_products_store(store)
        select('brands.id, brands.name, brands.slug, COUNT(products.id) AS products_count')
          .joins(:products)
          .where(products: { can_published: true, store_id: store })
          .group('brands.id')
          .order('products_count DESC')
      end
    end
  end
end
