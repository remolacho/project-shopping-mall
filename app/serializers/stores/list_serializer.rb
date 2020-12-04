class Stores::ListSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :mall_location, :what_we_do, :banner_url, :icon_url, :categories

  def banner_url
    rails_blob_url(object.banner, disposition: "attachment", only_path: true) if object.banner.attached?
  end

  def icon_url
    rails_blob_url(object.icon, disposition: "attachment", only_path: true) if object.icon.attached?
  end

  def categories
    ActiveModelSerializers::SerializableResource.new(object.products.counter_categories,
                                                     each_serializer: ::Categories::CounterSerializer)
  end
end
