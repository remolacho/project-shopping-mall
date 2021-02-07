class V1::Landing::ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/landing/products
  def index
    products = Product.group_stock.where(featured: true)
    render json: { success: true,
                   products: serializer(products) }, status: 200
  end

  def serializer(products_group)
    ActiveModelSerializers::SerializableResource.new(list(products_group.ids),
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end

  def list(products_group_ids)
    return [] unless products_group_ids.present?

    Product.list_by_ids(products_group_ids).order(Arel.sql('RANDOM()')).limit(10)
  end
end
