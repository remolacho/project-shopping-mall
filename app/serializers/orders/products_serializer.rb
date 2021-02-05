# frozen_string_literal: true

module Orders
  class ProductsSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attribute :id
    attribute :name
    attribute :price
    attribute :image_url
    attribute :order_item_id
    attribute :order_token
    attribute :category_name
    attribute :brand_name

    def id
      object.product_variant.product_id
    end

    def name
      object.product_variant.name
    end

    def price
      object.unit_value
    end

    def image_url
      image = object.product_variant.product.image
      return unless image.present?

      polymorphic_url(image, host: ENV['HOST_IMAGES'])
    end

    def order_item_id
      object.id
    end

    def category_name
      object.product_variant.product.category.name[I18n.locale.to_s]
    end

    def brand_name
      object.product_variant.product.brand.name
    end

    def order_token
      instance_options[:order_token]
    end
  end
end
