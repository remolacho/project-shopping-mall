class Landing::AdsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :image_url, :url_destination, :mobile_image_url

  def image_url
    polymorphic_url(object.image, host: ENV['HOST_IMAGES']) if object.image.attached?
  end

  def mobile_image_url
    polymorphic_url(object.mobile_image, host: ENV['HOST_IMAGES']) if object.mobile_image.attached?
  end

end