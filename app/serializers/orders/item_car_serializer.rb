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

  def total
    (object.item_qty * object.unit_value).to_f
  end

  def image_url
    return unless product_variant.product.image.attached?

    rails_blob_url(product_variant.product.image, disposition: "attachment", only_path: true)
  end

  def name
    product_variant.name
  end

  private

  def product_variant
    @product_variant ||= object.product_variant
  end
end
