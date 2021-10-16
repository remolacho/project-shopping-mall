module Products
  module Collections
    class CategoriesHierarchy

      attr_accessor :collection, :categories

      def initialize(collection:, categories_ids:)
        @collection = collection
        @categories = Category.where(id: categories_ids)
      end

      def perform
        list_tree(list)
      end

      def list_tree(categories)
        categories.map { |parent|
          next if parent[:added]

          parent[:added] = true
          parent.merge!(children: list_tree(list.select { |child| child[:parent_id] == parent[:id] }))
        }.compact
      end

      private

      def categories_list
        array_categories = []

        categories.each do |category|
          categories_ids = hierarchy(category)
          products_count = collection.products.counter_by_category(categories_ids)

          next if products_count.zero?

          array_categories << {
            id: category.id,
            name: category.name[I18n.locale.to_s],
            slug: category.slug,
            products_count: products_count,
            is_visible: true,
            parent_id: category.parent_id || 0,
            added: false
          }
        end

        array_categories.compact.sort_by{ |l| [l[:parent_id], l[:name]] }
      end

      def list
        @list ||= categories_list
      end

      def hierarchy(category)
        [category.id] | category.descendant_ids
      end
    end
  end
end