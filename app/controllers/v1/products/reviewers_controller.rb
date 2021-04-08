class V1::Products::ReviewersController < ApplicationController

  skip_before_action :authenticate_user!

  # GET v1/product/reviewers/:product_id
  def show
    service = ::Products::Reviewers.new(product: product, data: params)
    render json: {success: true, reviewers: service.perform}, status: 200
  end
end

