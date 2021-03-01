class Stores::DetailSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

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
    page = instance_options[:page].present? ? instance_options[:page].to_i : 1
    products = object.products.list.is_featured(false)
    products = filter_prices(products)
    products = filter_brand(products)
    products = filter_order(products)
    product_json(pagination(products, page), page)
  end

  def filter_order(products)
    return products unless instance_options[:order_by].present?

    products.order("product_variants.price #{instance_options[:order_by]}")
  end

  def filter_prices(products)
    return products unless instance_options[:prices].present?

    prices = data_array(instance_options[:prices])
    prices = prices.map { |p| p.split('-') }.flatten
    return products unless prices.present?

    products.where(product_variants: { price: prices.min..prices.max })
  end

  def filter_brand(products)
    return products unless instance_options[:brand_ids].present?

    brand_ids = data_array(instance_options[:brand_ids])
    return products unless brand_ids.present?

    products.where(brands: { id: brand_ids })
  end

  def data_array(values)
    return values if values.nil? || values.class.eql?(Array)

    eval(values)
  end

  def products_featured
    page = instance_options[:page_f].present? ? instance_options[:page_f].to_i : 1
    products = object.products.list.is_featured(true)
    product_json(pagination(products, page), page)
  end

  def pagination(objects, page)
    objects.page(page || 1).per(ENV['PER_PAGE'])
  end

  def product_json(objects, page)
    {
      per_page: ENV['PER_PAGE'].to_i,
      current_page: page,
      total_pages: objects.total_pages,
      total_objects: objects.total_count,
      list: ActiveModelSerializers::SerializableResource.new(objects,
                                                             each_serializer: ::Categories::ProductsListSerializer)
    }
  end
end
