class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :lastname, :email, :rut, :image

  def image
    rails_blob_url(object.image, disposition: "attachment", only_path: true) if object.image.attached?
  end
end
