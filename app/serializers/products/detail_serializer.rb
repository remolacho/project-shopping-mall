#  id                             :bigint           not null, primary key
#  deleted_at                     :datetime
#  hide_from_results              :boolean          default(FALSE)
#  name_translations              :hstore
#  rating                         :float            default(0.0)
#  short_description_translations :hstore
#  slug                           :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  brand_id                       :integer
#  category_id                    :integer
#  group_products_store_id        :integer
#  store_id                       :integer

class Products::DetailSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :short_description, :image_url
  attribute :variants
  attribute :brand
  attribute :category
  attribute :store

  def description
    object.description.try(:body)
  end

  def image_url
    polymorphic_url(object.image, host: "zofri-dev.etiner.com") if object.image.attached?
  end

  def variants
    objects = object.product_variants
                    .includes(variant_options_values: [:option_value, :option_type])
                    .is_active.order('is_master DESC')

    ActiveModelSerializers::SerializableResource.new(objects,
                                                     each_serializer: ::Products::VariantSerializer)

  end

  def brand
    object.brand&.name
  end

  def category
    object.category&.name[I18n.locale.to_s]
  end

  def store
    Stores::DetailSerializer.new(object.store)
  end
end
