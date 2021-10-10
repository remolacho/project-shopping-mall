# frozen_string_literal: true
  module Products
    module Collections
      class List
        include Rails.application.routes.url_helpers
        include ::ProductsFilters

        attr_accessor :collection, :data

        def initialize(collection:, data:)
          @collection = collection
          @data = data
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
              products: serializer(products_group),
              per_page: ENV['PER_PAGE'].to_i,
              total_pages: products_group.total_pages,
              total_objects: products_group.total_count,
              current_page: (data[:page] || 1).to_i
            }
          }
        end

        private

        def products
          collection_group = group_by_collection(collection)
          collection_group = filter_by_category(collection_group)
          collection_group = filter_brand(collection_group)
          collection_group = filter_rating(collection_group)
          collection_group = filter_prices(collection_group)
          pagination(collection_group)
        end

        def products_group
          @products_group ||= products
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
      end
    end
  end
