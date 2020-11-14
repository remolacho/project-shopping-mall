class V1::Categories::ProductsController < ApplicationController

  skip_before_action :authenticate_user!

  # GET /v1/category/:category_id/products
  def index
    service = Categories::ListProducts.new(category: category, data: params)
    render json: service.perform
  end
end
