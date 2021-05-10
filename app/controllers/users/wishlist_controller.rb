class Users::WishlistController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /users/wishlist
  def index
    products = current_user.wishlist
    render json: { success: true, wishlist: serializer(products) }, status: 200
  end

  # POST /users/wishlist/addItem
  def create
    current_user.wishlists.create!(product_id: product_params[:id])
    render json: {success: true, message: 'Se agrego el producto con éxito' }, status: 201
  end
  
  # DELETE /users/wishlist/:product_id
  def destroy
    item = current_user.wishlists.find_by(product_id: params[:id])
    item.destroy!
    render json: {success: true, message: 'Se retiro el producto con éxito' }, status: 200
  end

  private

  def product_params
    params.require(:product).permit(:id)
  end

  def serializer(products)
    ActiveModelSerializers::SerializableResource.new(list(products.ids), each_serializer: ::Categories::ProductsListSerializer)
  end

  def list(products_ids)
    return [] unless products_ids.present?
    Product.list_by_ids(products_ids)
  end

end