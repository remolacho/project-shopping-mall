class Categories::ListProducts

  attr_accessor :category, :data

  def initialize(category:, data:)
    @category = category
    @data = data
  end

  def perform
    products = list
    products = filter_brand(products)
    products = filter_rating(products)
    products = filter_prices(products)
    products = filter_order(products)
    products = pagination(products)

    {
      success: true,
      per_page: ENV['PER_PAGE'].to_i,
      total_pages: products.total_pages,
      total_objects: products.total_count,
      category: ::Categories::CategorySerializer.new(category),
      products: serializer(products)
    }
  end

  private

  def list
    Product.list.where(categories: {id: hierarchy})
  end

  def filter_brand(products)
    brand_ids = data_array(data.dig(:brand_ids))
    return products unless brand_ids.present?

    products.where(brands: {id: brand_ids})
  end

  def filter_rating(products)
    return products unless data.dig(:rating).present?

    range = data.dig(:rating).to_f..(data.dig(:rating).to_f + 0.9)
    products.where(products: {rating: range })
  end

  def filter_prices(products)
    return products unless data.dig(:prices).present?

    prices = data_array(data.dig(:prices))
    prices = prices.map{ |p| p.split('-') }.flatten
    return products unless prices.present?

    products.where(product_variants: {price: prices.min..prices.max})
  end

  def filter_order(products)
    return products.order('product_variants.price ASC') unless data.dig(:order_by).present?

    products.order("product_variants.price #{data.dig(:order_by)}")
  end

  def pagination(products)
    products.page(data.dig(:page) || 1).per(ENV['PER_PAGE'])
  end

  def hierarchy
    [category.id] | category.descendant_ids
  end

  def data_array(values)
    return values if values.nil? || values.class.eql?(Array)

    eval(values)
  end

  def serializer(products)
    ActiveModelSerializers::SerializableResource.new(products,
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end
end
