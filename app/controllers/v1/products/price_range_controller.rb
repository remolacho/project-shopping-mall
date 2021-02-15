class V1::Products::PriceRangeController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/priceRange?type=category&id=1
  def index
    service = Products::PriceRangeList.new(type: params[:type], id: params[:id])
    render json: service.perform, status: 200
  end
end
