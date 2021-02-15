class Products::BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :products_count, :is_visible

  def products_count
    return @count_products if @count_products.present?
    @count_products = Product.counter_by_brand(object.id)
  end

  def is_visible
    !products_count.zero?
  end
end