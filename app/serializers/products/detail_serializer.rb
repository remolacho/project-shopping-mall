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

  def description
    object.description.try(:body)
  end

  def image_url
    rails_blob_url(object.image, disposition: "attachment", only_path: true) if object.image.attached?
  end

  def variants
    object.product_variants
          .includes(variant_options_values: [:option_value ,:option_type])
          .is_active.order('is_master DESC').map do |variant|
      Products::VariantSerializer.new(variant)
    end
  end

  def brand
    object.brand&.name
  end

  def category
    object.category&.name[I18n.locale.to_s]
  end
end
