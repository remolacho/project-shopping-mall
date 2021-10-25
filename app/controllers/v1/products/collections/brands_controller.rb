class V1::Products::Collections::BrandsController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/collections/brands/:collection_slug?category_id=
  def index
    result = ::Products::Collections::BrandsList.new(category: category,
                                                     collection: collection).perform

    render json: { success: true, brands: result }, status: 200
  end

  protected

  def category
    Category.find_by(id: params[:category_id])
  end
end
