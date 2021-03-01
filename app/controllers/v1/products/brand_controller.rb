class V1::Products::BrandController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/brands?type=category&id=1
  def index
    render json: { success: true, brands: brands_serializer }, status: 200
  end

  protected

  def brands_serializer
    return GroupTitles::ListProductsBrand.new(group_title: group_title).perform if params[:type].eql?("group")

    if params[:type].eql?("store")
      results = Brand.joins(:products).where('brands.id = products.brand_id').where('products.store_id = ? AND products.featured = ?', store, false).group('brands.id')
      return  ActiveModelSerializers::SerializableResource.new(results,
                                                               each_serializer: ::Products::BrandSerializer).as_json.select { |c| c[:is_visible] }

    end

    Categories::ListProductsBrand.new(category: category).perform
  end

  def category
    Category.find(params[:id])
  end

  def store
    Store.find(params[:id])
  end

  def group_title
    GroupTitle.find(params[:id])
  end
end
