class V1::Categories::ParentsController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/categories/parents
  def index
    render json: {success: true, categories: serializer}, status: 200
  end

  private

  def serializer
    ActiveModelSerializers::SerializableResource.new(Category.roots,
                                                     each_serializer: ::Categories::CategorySerializer)
  end
end
