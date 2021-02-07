class Landing::AdsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url, :url_destination

  def image_url
    polymorphic_url(object.image, host: ENV['HOST_IMAGES']) if object.image.attached?
  end

end