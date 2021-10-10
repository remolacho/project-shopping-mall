# frozen_string_literal: true

module ProductsFilters
  extend ActiveSupport::Concern

  private

  def group_list
    Product.list
  end

  def group_by_store(store)
    store.products.list
  end

  def group_by_collection(collection)
    collection.products.list
  end

  def filter_by_category(products, is_present = true)
    return products if category.nil? && is_present

    products.where(products: { category_id: hierarchy })
  end

  def filter_by_title(products)
    result_hierarchy = hierarchy_title
    return products unless result_hierarchy.present?

    products.where(products: { category_id: result_hierarchy })
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

    products.where("product_variants.filter_price BETWEEN #{prices.min} AND #{prices.max}")
  end

  def pagination(products)
    products.page(data.dig(:page) || 1).per(ENV['PER_PAGE'])
  end

  def hierarchy
    [category.id] | category.descendant_ids
  end

  # Overrides method of concerns
  def hierarchy_title
    return [] unless group_title.present?

    categories = group_title.categories.uniq
    raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?

    categories.map(&:id) | categories.map(&:descendant_ids).flatten
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

    return products.order('reference_price ASC') unless data.dig(:order_by).present?

    products.order("reference_price #{data.dig(:order_by)}")
  end
end
