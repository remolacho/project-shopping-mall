class V1::Stores::ListController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/stores/list
  def index
    service = Stores::List.new(category: category_or_nil, data: params)
    render json: service.perform, status: 200
  end
end
