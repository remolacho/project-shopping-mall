class V1::Stores::DetailController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/stores/detail/:store_id
  def show

    service = Stores::Detail.new(store: store, data: params)
    render json: service.perform
  end
end
