# frozen_string_literal: true

module Products
  class List
    include ::ProductsFilters

    attr_accessor :type, :category, :data

    def initialize(type:, data:, category:)
      @type = type
      @category = category
      @data = data
    end

    def perform
      product = send(type)

      {
        success: true,
        per_page: ENV['PER_PAGE'].to_i,
        total_pages: product.list_group.total_pages,
        total_objects: product.list_group.total_count,
        products: serializer(product.list)
      }
    end

    private

    def discount
      products_group = group_list.with_discount
      products_group = filter_by_category(products_group)
      products_group = pagination(products_group)

      products_group_ids = products_group.ids

      list = if products_group_ids.present?
               Product.list_witout_master(products_group_ids)
                      .discount_not_nil
                      .order('product_variants.discount_value ASC')
                      .group_by(&:id).values.map(&:last)
             end

      Struct.new(:list_group, :list).new(products_group, list || [])
    end

    # Overrides method
    def serializer(products)
      ActiveModelSerializers::SerializableResource.new(products,
                                                       each_serializer: ::Categories::ProductsListSerializer)
    end
  end
end
