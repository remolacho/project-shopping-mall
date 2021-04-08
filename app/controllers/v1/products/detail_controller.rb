class V1::Products::DetailController < ApplicationController

  skip_before_action :authenticate_user!

  # GET /v1/product/detail/:product_id
  def show
    service = ::Products::Detail.new(user: current_user, product: product)
    render json: {success: true, product: service.perform}, status: 200
  end
end
