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
      per_page: ENV['ALGOLIA_PER_PAGE'].to_i,
      total_pages: products.total_pages,
      total_objects: products.total_count,
      products: serializer(products)
    }
  end

  private

  def list
    Product.joins(:brand, :store, :product_variants, :category)
           .select("products.id, categories.name::json->> '#{I18n.locale.to_s}' as category_name,
                    product_variants.price, brands.name as brand_name,
                    stores.name as store_name,
                    product_variants.is_master, product_variants.active as variant_active,
                    products.rating,
                    products.name_translations,
                    products.short_description_translations")
           .where(product_variants: { is_master: true, active: true })
           .where(stores: { active: true })
           .where(categories: {id: hierarchy})
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
    products.page(data.dig(:page) || 1).per(ENV['ALGOLIA_PER_PAGE'])
  end

  def hierarchy
    [category.id] | category.children.ids
  end

  def data_array(values)
    return values if values.nil? || values.class.eql?(Array)

    eval(values)
  end

  def serializer(products)
    products.map{ |product| Categories::ProductsListSerializer.new(product) }
  end
end
