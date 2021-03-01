module ProductsFiltersV2
  extend ActiveSupport::Concern

  private

  def group_list
    Product.list
  end

  def filter_by_category(products, is_present = true)
    return products if category.nil? && is_present

    products.where(products: { category_id: hierarchy })
  end

  def filter_brand(products)
    brand_ids = data_array(data.dig(:brand_ids))
    return products unless brand_ids.present?

    products.where(brands: { id: brand_ids })
  end

  def filter_rating(products)
    return products unless data.dig(:rating).present?

    range = data.dig(:rating).to_f..(data.dig(:rating).to_f + 0.9)
    products.where(products: { rating: range })
  end

  def filter_prices(products)
    return products unless data.dig(:prices).present?

    prices = data_array(data.dig(:prices))
    prices = prices.map { |p| p.split('-') }.flatten
    return products unless prices.present?

    prices = prices.map(&:to_f)
    products.where(product_variants: { price: prices.min..prices.max })
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
    ActiveModelSerializers::SerializableResource.new(list(products),
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end

  def list(products)
    return [] unless products.present?

    return products.order('product_variants.price ASC') unless data.dig(:order_by).present?

    products.order("product_variants.price #{data.dig(:order_by)}")
  end
end

