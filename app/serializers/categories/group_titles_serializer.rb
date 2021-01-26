class Categories::GroupTitlesSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :name, :slug, :image_url, :icon_url, :home, :burger
  attribute :categories

  def image_url
    polymorphic_url(object.image, host: "zofri-dev.etiner.com") if object.image.attached?
  end

  def icon_url
    polymorphic_url(object.icon, host: "zofri-dev.etiner.com") if object.icon.attached?
  end

  def categories
    ActiveModelSerializers::SerializableResource.new(object.categories,
                                                     each_serializer: ::Categories::WithChildrensSerializer)
                                                .as_json.select { |c| c[:is_visible] }
  end
end
