class Categories::GroupTitlesSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  attribute :categories

  def categories
    ActiveModelSerializers::SerializableResource.new(object.categories,
                                                     each_serializer: ::Categories::WithChildrensSerializer)
                                                .as_json.select { |c| c[:is_visible] }
  end
end
