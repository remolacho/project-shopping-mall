class V1::Categories::ChildrenController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/category/:category_id/children
  def index
    render json: { success: true, categories: serializer }, status: 200
  end

  def serializer
    ActiveModelSerializers::SerializableResource.new(category.children,
                                                     each_serializer: ::Categories::CategorySerializer)
                                                .as_json.select { |c| c[:is_visible] }
  end
end
