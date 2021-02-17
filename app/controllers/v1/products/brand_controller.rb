class V1::Products::BrandController < ApplicationController
  skip_before_action :authenticate_user!

  #  GET /v1/products/brands?type=category&id=1
  def index
    render json: { success: true, brands: ActiveModelSerializers::SerializableResource.new(brands,
      each_serializer: ::Products::BrandSerializer).as_json.select { |c| c[:is_visible]}
      }, status: 200
  end

  protected
  def brands
    case params[:type]
    when "category"
      Brand.joins(:categories).where(categories: { id: hierarchy }).group('brands.id')
    when "store"
      Brand.joins(:products).where('brands.id = products.brand_id').where('products.store_id = ? AND products.featured = ?', store, false ).group('brands.id')
    when "group"
      Brand.joins(:categories).where(categories: { id: hierarchy_titles }).group('brands.id')
    else
      Brand.joins(:categories).where(categories: { id: hierarchy }).group('brands.id')
    end
  end

  def category
    category = Category.find(params[:id])
  end

  def store
    store = Store.find(params[:id])
  end

  def group_title
    GroupTitle.find(params[:id])
  end
  
  def hierarchy
    [category.id] | category.descendant_ids
  end

  def hierarchy_titles
    categories = group_title.categories
    raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?
    categories.map(&:id) | categories.map(&:descendant_ids).flatten
  end
end
