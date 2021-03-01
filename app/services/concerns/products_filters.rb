#TODO Eliminar una ves este todo probado
module ProductsFilters
  extend ActiveSupport::Concern

  private

  def group_list
    Product.group_stock
  end

  def filter_by_category(products_group, is_present = true)
    return products_group if category.nil? && is_present

    products_group.where(products: { category_id: hierarchy })
  end

  #TODO deprecar
  def filter_brand(products_group)
    brand_ids = data_array(data.dig(:brand_ids))
    return products_group unless brand_ids.present?

    products_group.where(brands: { id: brand_ids })
  end

  #TODO deprecar
  def filter_rating(products_group)
    return products_group unless data.dig(:rating).present?

    range = data.dig(:rating).to_f..(data.dig(:rating).to_f + 0.9)
    products_group.where(products: { rating: range })
  end

  #TODO deprecar
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

  #TODO deprecar
  def data_array(values)
    return values if values.nil? || values.class.eql?(Array)

    eval(values)
  end

  #TODO deprecar pasar el que esta en el servicio Products::List
  def serializer(products_group)
    ActiveModelSerializers::SerializableResource.new(list(products_group.ids),
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end

  #TODO deprecar
  def list(products_group_ids)
    return [] unless products_group_ids.present?

    products = Product.list_by_ids(products_group_ids)
    return products.order('product_variants.price ASC') unless data.dig(:order_by).present?

    products.order("product_variants.price #{data.dig(:order_by)}")
  end
end
