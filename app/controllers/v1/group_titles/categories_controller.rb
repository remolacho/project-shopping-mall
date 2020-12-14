class V1::GroupTitles::CategoriesController < ApplicationController

  skip_before_action :authenticate_user!

  # GET /v1/groupTitles/categories
  def index
    render json: {success: true,
                  titles: serializer}, status: 200
  end

  # GET /v1/groupTitles/categories/:title_id
  def show
    render json: {success: true,
                  title: ::Categories::GroupTitlesSerializer.new(group_title) }, status: 200
  end

  private

  def serializer
    ActiveModelSerializers::SerializableResource.new(GroupTitle.includes(:categories).all,
                                                     each_serializer: ::Categories::GroupTitlesSerializer)
  end
end

