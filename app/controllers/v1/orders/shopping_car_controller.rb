class V1::Orders::ShoppingCarController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/orders/shoppingCar?order_token
  def index
    service = ShoppingCar::Items.new(user: with_user, order: order)
    render json: service.perform, state: 200
  end

  # GET /v1/orders/shoppingCar/addItem?order_token&product_variant_id
  def create
    service = ShoppingCar::AddItem.new(user: with_user,
                                       order: order,
                                       product_variant: product_variant,
                                       store: product_variant.product.store)

    render json: service.perform, state: 200
  end

  # PUT /v1/orders/shoppingCar/:order_item_id?order_token
  def update
    service = ShoppingCar::UpdateItem.new(user: with_user,
                                          order: order,
                                          order_item: order_item,
                                          data: allowed_params)

    render json: service.perform, state: 200
  end

  # DELETE /v1/orders/shoppingCar/:order_item_id?order_token
  def destroy
    service = ShoppingCar::DeleteItem.new(user: with_user,
                                          order: order,
                                          order_item: order_item)

    render json: service.perform, state: 200
  end

  private

  def allowed_params
    params.require(:order_item).permit(:item_qty)
  end
end
