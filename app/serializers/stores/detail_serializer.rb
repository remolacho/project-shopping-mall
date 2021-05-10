# frozen_string_literal: true

module Stores
  class DetailSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    include ::ProductsFilters

    attributes :id, :name

    attribute :banner_url, if: :all_fields?
    attribute :icon_url, if: :all_fields?
    attribute :what_we_do, if: :all_fields?
    attribute :facebook, if: :all_fields?
    attribute :instagram, if: :all_fields?
    attribute :twitter, if: :all_fields?
    attribute :mall_location, if: :all_fields?
    attribute :products, if: :with_product?
    attribute :products_featured, if: :with_product?

    def banner_url
      polymorphic_url(object.banner, host: ENV['HOST_IMAGES']) if object.banner.attached?
    end

    def icon_url
      polymorphic_url(object.icon, host: ENV['HOST_IMAGES']) if object.icon.attached?
    end

    def all_fields?
      instance_options[:all_fields] == true
    end

    def with_product?
      instance_options[:with_product] == true
    end

    def products
      products = group_by_store(object)
      products = filter_by_category(products)
      products = filter_prices(products)
      products = filter_brand(products)
      products = filter_rating(products)
      products = pagination(products, data[:page])
      product_json(products, data[:page])
    end

    def products_featured
      products = group_by_store(object).is_featured(true)
      products = pagination(products, data[:page_f])
      product_json(products, data[:page_f])
    end

    # overwrite method of ProductsFilters
    def pagination(products, page)
      products.page(page || 1).per(ENV['PER_PAGE'])
    end

    def product_json(products, page)
      {
        per_page: ENV['PER_PAGE'].to_i,
        current_page: page,
        total_pages: products.total_pages,
        total_objects: products.total_count,
        list: serializer(products)
      }
    end

    def category
      @category ||= Category.find_by(id: instance_options[:category_id])
    end

    def data
      @data ||= {
        prices: instance_options[:prices],
        rating: instance_options[:rating],
        brand_ids: instance_options[:brand_ids],
        order_by: instance_options[:order_by],
        page: instance_options[:page].present? ? instance_options[:page].to_i : 1,
        page_f: instance_options[:page_f].present? ? instance_options[:page_f].to_i : 1
      }
    end
  end
end
