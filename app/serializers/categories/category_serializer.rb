class Categories::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  attribute :children, if: :has_children?

  def name
    object.name[I18n.locale.to_s]
  end

  def children
    ActiveModelSerializers::SerializableResource.new(object.children,
                                                     each_serializer: ::Categories::CategorySerializer)
  end

  def has_children?
    instance_options[:has_children] == true
  end
end
