require 'rails_helper'

RSpec.describe V1::Categories::ProductsController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Products list by category' do
    context 'Validation' do
      it 'error secret api!!!' do
        request.headers['secret-api'] = 'Secret error'
        get :index, params: {category_id: root_category.id, page: 2}, as: :json
        expect(response.status).to eq(403)
      end

      it 'success all hierarchy categories!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id, page: 1}, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 10).to eq(true)
      end

      it 'success all category child!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: category_child.id, page: 1}, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success all category child page 2!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: category_child.id, page: 2}, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').size == 2).to eq(true)
      end

      it 'success by brand' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id, page: 1, brand_ids: [brands_list.first.id]}, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success by rating' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id,
                             page: 1,
                             rating: 3}, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success order by price DESC' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id,
                             page: 1,
                             order_by: 'DESC'}, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 10).to eq(true)
      end

      it 'success filter prices' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id,
                             page: 1,
                             prices: ['1000-1500']}, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success filter prices string' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: category_child.id,
                             page: 1,
                             prices: "['4000-5000']"}, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success multi filter' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id,
                             page: 1,
                             brand_ids: [brands_list.first.id].to_s,
                             prices: ['1000-1500'],
                             rating: 3,
                             order_by: 'DESC'}, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'error multi filter' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: {category_id: root_category.id,
                             page: 1,
                             brand_ids: [brands_list.first.id],
                             rating: 4,
                             order_by: 'DESC'}, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 0).to eq(true)
      end

    end
  end
end