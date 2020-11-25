class V1::Orders::ShoppingCartController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/shoppingCart?order_token
  def index
    service = ShoppingCart::Items.new(user: with_user, order: order)
    render json: service.perform, status: 200
  end

  # GET /v1/orders/shoppingCart/addItem?order_token&product_variant_id
  def create
    service = ShoppingCart::AddItem.new(user: with_user,
                                        order: order,
                                        product_variant: product_variant,
                                        store: product_variant.product.store)

    render json: service.perform, status: 200
  end

  # PUT /v1/orders/shoppingCart/:order_item_id?order_token
  def update
    service = ShoppingCart::UpdateItem.new(user: with_user,
                                           order: order,
                                           order_item: order_item,
                                           data: allowed_params)

    render json: service.perform, status: 200
  end

  # DELETE /v1/orders/shoppingCart/:order_item_id?order_token
  def destroy
    service = ShoppingCart::DeleteItem.new(user: with_user,
                                           order: order,
                                           order_item: order_item)

    render json: service.perform, status: 200
  end

  private

  def allowed_params
    params.require(:order_item).permit(:item_qty)
  end
end
