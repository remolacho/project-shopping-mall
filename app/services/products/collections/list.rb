# frozen_string_literal: true
  module Products
    module Collections
      class List
        include Rails.application.routes.url_helpers
        include ::ProductsFilters

        attr_accessor :collection, :data, :collection_group

        def initialize(collection:, data:)
          @collection = collection
          @data = data
          @collection_group = products
        end

        def perform
          raise ActiveRecord::RecordNotFound, 'The collection is not start' unless start_valid?
          raise ActiveRecord::RecordNotFound, 'The collection is finished' unless end_valid?

          {
            success: true,
            collection: {
              id: collection.id,
              name: collection.name,
              slug: collection.slug,
              image_url: image_url,
              products: serializer(pagination_group),
              per_page: ENV['PER_PAGE'].to_i,
              total_pages: pagination_group.total_pages,
              total_objects: pagination_group.total_count,
              current_page: (data[:page] || 1).to_i,
              categories: categories
            }
          }
        end

        private

        def products
          products_list = group_by_collection(collection)
          products_list = filter_by_category(products_list)
          products_list = filter_brand(products_list)
          products_list = filter_rating(products_list)
          filter_prices(products_list)
        end

        def pagination_group
          @pagination_group ||= pagination(collection_group)
        end

        def start_valid?
          collection.start_date <= Time.current
        end

        def end_valid?
          collection.end_date > Time.current
        end

        def category
          @category ||= Category.find_by(id: data.dig(:category_id))
        end

        def image_url
          polymorphic_url(collection.image, host: ENV['HOST_IMAGES']) if collection.image.attached?
        end

        def categories
          return [] unless collection_group.present?

          Products::Collections::CategoriesHierarchy.new(collection: collection,
                                                         categories_ids: collection_group.map(&:category_id).uniq).perform
        end
      end
    end
  end
