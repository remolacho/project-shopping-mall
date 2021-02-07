require 'rails_helper'

RSpec.describe V1::Orders::ProductsController, type: :controller do
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

    it 'error the order is not completed'do
      get :index, params: { order_token: current_order.token }, as: :json
      expect(current_order.order_items.empty?).to eq(true)
      expect(response.status).to eq(404)
    end

    it 'error list the order is not completed' do
      list_order_item
      get :index, params: { order_token: current_order.token }, as: :json
      expect(current_order.order_items.empty?).to eq(false)
      expect(response.status).to eq(404)
    end

    it 'success all list' do
      current_order.update(state: Order::IS_COMPLETED)
      list_order_item

      get :index, params: { order_token: current_order.token }, as: :json
      body = JSON.parse(response.body)
      expect(body['products'].size == list_order_item.size).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success list skip products with review' do
      current_order.update(state: Order::IS_COMPLETED)

      item = list_order_item.first
      current_order.reviews.create(product_id: item.product_variant.product_id, score: 4)

      get :index, params: { order_token: current_order.token }, as: :json
      body = JSON.parse(response.body)
      expect(body['products'].size == (list_order_item.size - 1)).to eq(true)
      expect(response.status).to eq(200)
    end
  end
end
