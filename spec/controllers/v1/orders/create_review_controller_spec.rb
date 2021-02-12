require 'rails_helper'

RSpec.describe V1::Orders::ProductsController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "GET #review" do
    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
    }

    let(:body) {
      {
        order_token: current_order.token,
        review: {
          comment: 'test comment',
          score: 4,
          product_id: list_order_item.first.product_variant.product_id
        }
      }
    }

    it 'error the order is not completed' do
      post :review, params: body, as: :json
      expect(response.status).to eq(404)
    end

    it 'error the product not found' do
      current_order.update(state: Order::IS_COMPLETED)
      body[:review][:product_id] = 999
      post :review, params: body, as: :json
      expect(response.status).to eq(404)
    end

    it 'error the score is not valid' do
      current_order.update(state: Order::IS_COMPLETED)
      body[:review][:score] = nil
      post :review, params: body, as: :json
      expect(response.status).to eq(422)
    end

    it 'error duplicate review' do
      current_order.update(state: Order::IS_COMPLETED)

      current_order.reviews.create(
        product_id: list_order_item.first.product_variant.product_id,
        comment: '',
        score: 5
      )

      post :review, params: body, as: :json
      expect(response.status).to eq(404)
    end

    it 'success create review' do
      current_order.update(state: Order::IS_COMPLETED)
      post :review, params: body, as: :json
      result = JSON.parse(response.body)
      product = Product.find(list_order_item.first.product_variant.product_id)
      expect(result['products'].size < list_order_item.size).to eq(true)
      expect(product.rating).to eq(body[:review][:score])
      expect(response.status).to eq(200)
    end
  end
end
