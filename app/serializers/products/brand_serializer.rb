class Products::BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :products_count, :is_visible

  def is_visible
    true
  end
end
