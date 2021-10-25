require 'rails_helper'

RSpec.describe V1::Products::Collections::ListController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe "GET #index" do
    it 'error secret api!!!' do
      request.headers['secret-api'] = 'Secret error'
      get :index, params: { collection_slug: new_collection.slug }, as: :json
      expect(response.status).to eq(403)
    end

    it 'error collection slug!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      get :index, params: { collection_slug: 'error-slug' }, as: :json
      expect(response.status).to eq(404)
    end

    it 'error collection inactive!!!' do
      new_collection.status = Collection::STATUS_INACTIVE
      new_collection.save

      request.headers['secret-api'] = ENV['SECRET_API']
      get :index, params: { collection_slug: new_collection.slug }, as: :json
      expect(response.status).to eq(404)
    end

    it 'error collection not start!!!' do
      new_collection.start_date = Time.now + 1.day
      new_collection.save

      request.headers['secret-api'] = ENV['SECRET_API']
      get :index, params: { collection_slug: new_collection.slug }, as: :json
      expect(response.status).to eq(404)
    end

    it 'error collection is finished!!!' do
      new_collection.end_date = Time.now
      new_collection.save

      request.headers['secret-api'] = ENV['SECRET_API']
      get :index, params: { collection_slug: new_collection.slug }, as: :json
      expect(response.status).to eq(404)
    end

    it 'success all list!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      total_product = collection_products.size

      get :index, params: { collection_slug: new_collection.slug, page: 1 }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('collection', 'total_objects') == total_product).to eq(true)
      expect(body.dig('collection', 'categories').present?).to eq(true)
      expect(body.dig('collection', 'categories').first['children'].present?).to eq(true)
    end

    it 'success list by category!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      collection_products
      get :index, params: { collection_slug: new_collection.slug, category_id: category_child.id }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('collection', 'total_objects') == 1).to eq(true)
    end

    it 'success list by brand!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']

      collection_products

      get :index, params: { collection_slug: new_collection.slug,
                            category_id: category_child.id,
                            brand_ids: [brands_list.last.id] }, as: :json

      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('collection', 'total_objects') == 1).to eq(true)
    end

    it 'success list by rating!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']

      collection_products

      get :index, params: { collection_slug: new_collection.slug,
                            category_id: category_child.id,
                            rating: 3}, as: :json

      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('collection', 'total_objects') == 1).to eq(true)
    end

    it 'success list by prices!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']

      collection_products

      get :index, params: { collection_slug: new_collection.slug,
                            category_id: category_child.id,
                            prices: "['4000-5000']"}, as: :json

      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('collection', 'total_objects') == 1).to eq(true)
    end
  end
end
