require 'rails_helper'

RSpec.describe V1::Products::ListController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'list products by attribute' do
    context '#recents' do
      it 'success list empty' do
        request.headers['secret-api'] = ENV['SECRET_API']
        Product.update_all(created_at: Time.now + 30.days)
        get :recents, params: { page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').empty?).to eq(true)
        expect(response.status).to eq(200)
      end

      it 'success list' do
        request.headers['secret-api'] = ENV['SECRET_API']
        Product.update_all(created_at: Time.now + 30.days)

        product = products_category.last
        product.created_at = (Time.now - 25.days)
        product.save

        get :recents, params: { page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').empty?).to eq(false)
        expect(response.status).to eq(200)
      end

      it 'success all hierarchy categories skip other category of other title!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        total_product = (products_category.size + products_category_child.size + products_category_child_depth_3.size)

        Product.update_all(created_at: Time.now + 30.days)

        product = products_category.last
        product.created_at = (Time.now - 25.days)
        product.save

        product = products_category_child_depth_3.last
        product.created_at = (Time.now - 20.days)
        product.save

        product = products_category_2.last
        product.created_at = (Time.now - 15.days)
        product.save

        get :recents, params: { title_id: group_titles.first.id, page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') < total_product).to eq(true)
        expect(body.dig('total_objects')).to eq(2) # 2 productos en toda la jerarquia
      end
    end
  end
end

