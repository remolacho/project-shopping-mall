class Categories::ListProducts
  attr_accessor :category, :data

  def initialize(category:, data:)
    @category = category
    @data = data
  end

  def perform
    products_group = group_list
    products_group = filter_brand(products_group)
    products_group = filter_rating(products_group)
    products_group = filter_prices(products_group)
    products_group = pagination(products_group)

    {
      success: true,
      per_page: ENV['PER_PAGE'].to_i,
      total_pages: products_group.total_pages,
      total_objects: products_group.total_count,
      category: ::Categories::CategorySerializer.new(category),
      products: serializer(products_group)
    }
  end

  private

  def group_list
    Product.group_stock.where(products: { category_id: hierarchy })
  end

  def filter_brand(products_group)
    brand_ids = data_array(data.dig(:brand_ids))
    return products_group unless brand_ids.present?

    products_group.where(brands: { id: brand_ids })
  end

  def filter_rating(products_group)
    return products_group unless data.dig(:rating).present?

    range = data.dig(:rating).to_f..(data.dig(:rating).to_f + 0.9)
    products_group.where(products: { rating: range })
  end

  def filter_prices(products_group)
    return products_group unless data.dig(:prices).present?

    prices = data_array(data.dig(:prices))
    prices = prices.map { |p| p.split('-') }.flatten
    return products_group unless prices.present?

    products_group.where(product_variants: { price: prices.min..prices.max })
  end

  def pagination(products_group)
    products_group.page(data.dig(:page) || 1).per(ENV['PER_PAGE'])
  end

  def hierarchy
    [category.id] | category.descendant_ids
  end

  def data_array(values)
    return values if values.nil? || values.class.eql?(Array)

    eval(values)
  end

  def serializer(products_group)
    ActiveModelSerializers::SerializableResource.new(list(products_group.ids),
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end

  def list(products_group_ids)
    return [] unless products_group_ids.present?

    products = Product.list_by_ids(products_group_ids)
    return products.order('product_variants.price ASC') unless data.dig(:order_by).present?

    products.order("product_variants.price #{data.dig(:order_by)}")
  end
end
