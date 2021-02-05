# == Schema Information
#
# Table name: order_items
#
#  id                 :bigint           not null, primary key
#  item_qty           :integer
#  unit_value         :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer          not null
#  product_variant_id :bigint
#  store_id           :bigint
#  store_order_id     :bigint

class Orders::ItemCarSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :item_qty, :unit_value, :product_variant_id
  attribute :total
  attribute :image_url
  attribute :name
  attribute :weight
  attribute :height
  attribute :width
  attribute :length

  def total
    (object.item_qty * object.unit_value).to_f
  end

  def image_url
    image = product_variant.product.image
    return unless image.present?

    polymorphic_url(image, host: ENV['HOST_IMAGES'])
  end

  def name
    product_variant.name
  end

  def weight
    product_variant.weight
  end

  def height
    product_variant.height
  end

  def width
    product_variant.width
  end

  def length
    product_variant.length
  end

  private

  def product_variant
    @product_variant ||= object.product_variant
  end
end
