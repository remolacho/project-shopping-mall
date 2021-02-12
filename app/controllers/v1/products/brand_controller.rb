class V1::Products::BrandController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/brands?category_id=1
  def index
    category = Category.find(params[:category_id])
    categories_ids = [category.id] | category.descendant_ids
    brands = Brand.joins(:categories).where(categories: { id: categories_ids })
    render json: { success: true, brands: ActiveModelSerializers::SerializableResource.new(brands,
      each_serializer: ::Products::BrandSerializer).as_json.select { |c| c[:is_visible]}}, status: 200
  end
end
