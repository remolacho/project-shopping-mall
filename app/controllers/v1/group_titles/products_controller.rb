class V1::GroupTitles::ProductsController < ApplicationController

  skip_before_action :authenticate_user!

  # GET /v1/groupTitles/:title_id/products
  def index
    service = GroupTitles::ListProducts.new(group_title: group_title, data: params)
    render json: service.perform, status: 200
  end
end
