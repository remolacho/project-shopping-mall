module Products
  module Collections
    class BrandsList
      include ::ProductsFilters

      attr_accessor :collection, :category

      def initialize(collection:, category:)
        @category = category
        @collection = collection
      end

      def perform
        products = group_by_collection(collection)
        products = filter_by_category(products)
        Brand.group_products(products.map(&:id))
      end
    end
  end
end
