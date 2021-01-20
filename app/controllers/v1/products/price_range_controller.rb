class V1::Products::PriceRangeController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/priceRange
  def index
    service = Products::PriceRangeList.new
    render json: service.perform, status: 200
  end
end
