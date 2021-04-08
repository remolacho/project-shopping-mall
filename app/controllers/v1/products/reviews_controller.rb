class V1::Products::ReviewsController < ApplicationController

  skip_before_action :authenticate_user!

  # GET v1/product/reviews/:product_id
  def show
    service = ::Products::Reviews.new(product: product)
    render json: {success: true, reviews: service.perform}, status: 200
  end
end
