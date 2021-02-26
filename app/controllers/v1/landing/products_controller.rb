class V1::Landing::ProductsController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/landing/products
  def index
    products = Product.list.is_featured(true)
    render json: { success: true,
                   products: serializer(products) }, status: 200
  end

  def serializer(products)
    ActiveModelSerializers::SerializableResource.new(products.order(Arel.sql('RANDOM()')).limit(30),
                                                     each_serializer: ::Categories::ProductsListSerializer)
  end
end
