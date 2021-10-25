class V1::Products::Collections::PriceRangeController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/collections/price_range/:collection_slug?category_id
  def index
    service = ::Products::Collections::PriceRangeList.new(collection: collection, category: category)
    render json: service.perform, status: 200
  end

  protected

  def category
    Category.find_by(id: params[:category_id])
  end
end
