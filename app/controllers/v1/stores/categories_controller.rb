class V1::Stores::CategoriesController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/stores/categories/:store_id
  def show
    service = Stores::CategoriesList.new(store: store)
    render json: { success: true, categories: service.perform }
  end

  # GET /v1/stores/categories/:store_id/children/:category_id
  def children
    service = Stores::CategoriesList.new(store: store, category: category)
    render json: { success: true, categories: service.perform }
  end
end
