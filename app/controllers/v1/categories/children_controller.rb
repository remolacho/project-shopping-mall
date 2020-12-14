class V1::Categories::ChildrenController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/category/:category_id/children
  def index
    render json: {success: true,
                  category: ::Categories::CategorySerializer.new(category,
                                                                 has_children: true)}, status: 200
  end
end
