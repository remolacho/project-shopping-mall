class Stores::DetailSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name

  attribute :banner_url, if: :all_fields?
  attribute :icon_url, if: :all_fields?
  attribute :what_we_do, if: :all_fields?
  attribute :facebook, if: :all_fields?
  attribute :instagram, if: :all_fields?
  attribute :twitter, if: :all_fields?
  attribute :mall_location, if: :all_fields?

  def banner_url
    rails_blob_url(object.banner, disposition: "attachment", only_path: true) if object.banner.attached?
  end

  def icon_url
    rails_blob_url(object.icon, disposition: "attachment", only_path: true) if object.icon.attached?
  end

  def all_fields?
    instance_options[:all_fields] == true
  end

  def with_product?
    instance_options[:with_product] == true
  end

  def products
    page = instance_options[:page].present? ? instance_options[:page].to_i : 1
    objects = object.products.list.is_featured(false)
    product_json(pagination(objects, page), page)
  end

  def products_featured
    page = instance_options[:page_f].present? ? instance_options[:page_f].to_i : 1
    objects = object.products.list.is_featured(true)
    product_json(pagination(objects, page), page)
  end

  def pagination(objects, page)
    objects.page(page || 1).per(ENV['PER_PAGE'])
  end

  def product_json(objects, page)
    {
        per_page: ENV['PER_PAGE'].to_i,
        current_page: page,
        total_pages: objects.total_pages,
        total_objects: objects.total_count,
        list: ActiveModelSerializers::SerializableResource.new(objects,
                                                               each_serializer: ::Categories::ProductsListSerializer)
    }
  end
end
