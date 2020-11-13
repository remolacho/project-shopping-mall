class Categories::ProductsListSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes  :id,
              :rating,
              :image_url,
              :name,
              :short_description,
              :category_name,
              :price,
              :brand_name,
              :store_name,
              :is_master,
              :variant_active

  def category_name
    object.category_name
  end

  def price
    object.price
  end

  def brand_name
    object.brand_name
  end

  def store_name
    object.store_name
  end

  def is_master
    object.is_master
  end

  def variant_active
    object.variant_active
  end

  def image_url
    rails_blob_url(object.image, disposition: "attachment", only_path: true) if object.image.attached?
  end
end