class V1::Products::ListController < ApplicationController
  skip_before_action :authenticate_user!

  # GET v1/products/discount/list?page=1&category_id=
  def discount
    service = Products::List.new(type: 'discount'.freeze,
                                 data: params,
                                 category: category_or_nil)

    render json: service.perform
  end

  # GET v1/products/rating/list?page=1&category_id=
  def rating
    service = Products::List.new(type: 'rating'.freeze,
                                 data: params,
                                 category: category_or_nil)

    render json: service.perform
  end
end
