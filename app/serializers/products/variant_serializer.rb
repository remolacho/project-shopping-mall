#  id                             :bigint           not null, primary key
#  active                         :boolean
#  deleted_at                     :datetime
#  discount_value                 :float
#  height                         :float
#  internal_sku                   :string
#  is_master                      :boolean          default(FALSE)
#  length                         :float
#  name_translations              :hstore
#  price                          :float
#  short_description_translations :hstore
#  sku                            :string
#  weight                         :float
#  width                          :float
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  product_id                     :integer

class Products::VariantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :short_description,
             :weight,
             :width,
             :height,
             :length,
             :is_master,
             :price,
             :discount_price,
             :current_stock

  attribute :images_urls
  attribute :option_variants

  def discount_price
    object.discount_value
  end

  def images_urls
    object.images.map do |img|
      next '' unless img.present?

      polymorphic_url(img, host: ENV['HOST_IMAGES'])
    end
  end

  def option_variants
    object.variant_options_values.map do |option|
      {
        id: option.id,
        type: option.option_type.name[I18n.locale.to_s],
        value: option.option_value.value[I18n.locale.to_s]
      }
    end
  end
end
