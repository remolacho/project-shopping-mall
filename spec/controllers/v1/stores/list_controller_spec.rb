require 'rails_helper'

RSpec.describe V1::Stores::ListController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'stores_products_stuff'

  describe "GET #index" do
    it "returns success all stores actives of the hierarchy category" do
      request.headers['secret-api'] = ENV['SECRET_API']

      products_list

      get :index, params: {category_id: root_category.id, page: 1}, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('total_objects').zero?).to eq(false)
      expect(body.dig('stores').map{|store| store['id']}.repeated_elements.size.zero?).to eq(true)
      expect(response).to have_http_status(:success)
    end

    it "returns success all stores actives by order" do
      request.headers['secret-api'] = ENV['SECRET_API']

      get :index, params: {order_by: 'DESC', page: 1}, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('total_objects').zero?).to eq(false)
      expect(response).to have_http_status(:success)
    end

    it "returns success all stores actives by name" do
      request.headers['secret-api'] = ENV['SECRET_API']

      get :index, params: {term: Store.first.name[0..4], page: 1}, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('total_objects').zero?).to eq(false)
      expect(response).to have_http_status(:success)
    end

    it "returns success all stores actives with filters" do
      request.headers['secret-api'] = ENV['SECRET_API']

      get :index, params: {category_id: root_category.id, term: Store.first.name[0..4], page: 1}, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('total_objects').zero?).to eq(false)
      expect(response).to have_http_status(:success)
    end

  end

end
