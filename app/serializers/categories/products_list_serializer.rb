class Categories::ProductsListSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes  :id,
              :rating,
              :image_url,
              :name,
              :short_description,
              :category_name,
              :price,
              :discount_price,
              :brand_name,
              :store_name,
              :is_master,
              :variant_active,
              :featured

  def discount_price
    object.discount_value
  end

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
    polymorphic_url(object.image, host: "zofri-dev.etiner.com") if object.image.attached?
  end
end