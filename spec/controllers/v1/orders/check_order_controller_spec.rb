require 'rails_helper'

RSpec.describe V1::Orders::CheckOrderController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "GET #show" do

    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
    }

    it 'success there are errors in price' do
      item = list_order_item.last
      product_variant = item.product_variant
      product_variant.price = 9999
      product_variant.save
      get :show, params: {order_token: current_order.token}
      body = JSON.parse(response.body)
      expect(response.status).to eq(203)
      expect(body['items_errors'].present?).to eq(true)
    end

    it 'success with stock_movements' do
      list_order_item
      get :show, params: {order_token: current_order.token}
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size.zero?).to eq(false)
      expect(stock_movements.all?{|movement| movement.quantity < 0}).to eq(true)
    end

    it 'the user repeat the order check and not duplicate stock negative' do
      list_order_item
      get :show, params: {order_token: current_order.token}
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size == list_order_item.size).to eq(true)
      expect(stock_movements.all?{|movement| movement.quantity < 0}).to eq(true)

      get :show, params: {order_token: current_order.token}
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size == list_order_item.size).to eq(true)
      expect(stock_movements.all?{|movement| movement.quantity < 0}).to eq(true)
    end

  end

end
