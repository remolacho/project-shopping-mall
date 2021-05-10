class V1::Products::ListController < ApplicationController
  skip_before_action :authenticate_user!

  # GET v1/products/discount/list?page=1&title_id=
  def discount
    service = Products::List.new(type: 'discount'.freeze,
                                 data: params,
                                 group_title: group_title_or_nil)

    render json: service.perform
  end

  # GET v1/products/rating/list?page=1&title_id=
  def rating
    service = Products::List.new(type: 'rating'.freeze,
                                 data: params,
                                 group_title: group_title_or_nil)

    render json: service.perform
  end

  # GET v1/products/recents/list?page=1&title_id=
  def recents
    service = Products::List.new(type: 'recents'.freeze,
                                 data: params,
                                 group_title: group_title_or_nil)

    render json: service.perform
  end
end
