class V1::Stores::DetailController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/stores/detail/:store_id
  def show
    render json: { success: true,
                   store: ::Stores::DetailSerializer.new(store,
                                                         page: params[:page],
                                                         page_f: params[:page_f],
                                                         order_by: params[:order_by],
                                                         prices: params[:prices],
                                                         brand_ids: params[:brand_ids],
                                                         all_fields: true,
                                                         with_product: true) }, status: 200
  end
end