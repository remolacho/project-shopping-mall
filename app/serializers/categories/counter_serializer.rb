class Categories::CounterSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :count

  def name
    object.category_name[I18n.locale.to_s]
  end

  def count
    object.total
  end
end
