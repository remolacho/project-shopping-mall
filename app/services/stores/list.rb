class Stores::List

  attr_accessor :category, :data

  def initialize(category:, data:)
    @category = category
    @data = data
  end

  def perform
    stores = all
    stores = filter_name(stores)
    stores = filter_category(stores)
    stores = filter_order(stores)
    stores = pagination(stores)

    {
      success: true,
      per_page: ENV['PER_PAGE'].to_i,
      total_pages: stores.total_pages,
      total_objects: stores.total_count,
      stores: serializer(stores)
    }
  end

  private

  def all
    Store.is_active
  end

  def filter_name(stores)
    return stores unless data.dig(:term).present?

    stores.where('stores.name ILIKE ?', "%#{data.dig(:term)}%")
  end

  def filter_category(stores)
    return stores unless category.present?

    categories_ids = [category.id] | category.children.ids

    stores.joins(:products)
          .where(products: { category_id: categories_ids })
  end

  def filter_order(stores)
    return stores.order('stores.name ASC') unless data.dig(:order_by).present?

    stores.order("stores.name #{data.dig(:order_by)}")
  end

  def pagination(stores)
    stores.select('DISTINCT(stores.id), stores.name, stores.mall_location, stores.what_we_do')
          .page(data.dig(:page) || 1)
          .per(ENV['PER_PAGE'])
  end

  def serializer(stores)
    ActiveModelSerializers::SerializableResource.new(stores,
                                                     each_serializer: ::Stores::ListSerializer)
  end
end
