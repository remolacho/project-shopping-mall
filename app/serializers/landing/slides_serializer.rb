class Landing::SlidesSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :original, :url_destination

  def original
    polymorphic_url(object.image, host: "http://localhost:3002") if object.image.attached?
  end

end