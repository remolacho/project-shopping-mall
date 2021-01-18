class Categories::WithChildrensSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :products_count, :is_visible, :childrens

  def name
    object.name[I18n.locale.to_s]
  end

  def childrens
    ActiveModelSerializers::SerializableResource.new(object.children,
                                                     each_serializer: ::Categories::CategorySerializer)
                                                .as_json.select { |c| c[:is_visible] }
  end

  def products_count
    return @count_products if @count_products.present?

    categories_ids = [object.id] | object.descendant_ids
    @count_products = Product.counter_by_category(categories_ids)
  end

  def is_visible
    !products_count.zero?
  end
end