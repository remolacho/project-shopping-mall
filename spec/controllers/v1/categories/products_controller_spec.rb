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
        get :index, params: { category_id: root_category.id, page: 2 }, as: :json
        expect(response.status).to eq(403)
      end

      it 'success all hierarchy categories!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        total_product = (products_category.size +
            products_category_child.size +
            products_category_child_depth_3.size)

        get :index, params: { category_id: root_category.id, page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == total_product).to eq(true)
      end

      it 'Only products with variants inactives' do
        request.headers['secret-api'] = ENV['SECRET_API']
        total_product = (products_category.size +
            products_category_child.size +
            products_category_child_depth_3.size)

        product_first = products_category_child.first
        product_first.product_variants.update_all(active: false)

        get :index, params: { category_id: root_category.id, page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') < total_product).to eq(true)
        expect(total_product).to eq(15)
        expect(body.dig('total_objects')).to eq(14) # 14 por que se desactivan las variantes de un producto
      end

      it 'success all category child!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        total_product = products_category_child.size + products_category_child_depth_3.size
        get :index, params: { category_id: category_child.id, page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == total_product).to eq(true)
      end

      it 'success all category child page 2!!!' do
        products_category_child
        products_category_child_depth_3

        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: category_child.id, page: 4 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').size == 1).to eq(true)
      end

      it 'success by brand' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id, page: 1, brand_ids: [brands_list.first.id] }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success by rating' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1,
                              rating: 3 }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success order by price DESC' do
        total_product = (products_category.size +
            products_category_child.size +
            products_category_child_depth_3.size)

        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1,
                              order_by: 'DESC' }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == total_product).to eq(true)
      end

      it 'success filter prices' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1,
                              prices: ['1000-1500'] }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'success filter prices string' do
        products_category_child
        products_category_child_depth_3
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: category_child.id,
                              page: 1,
                              prices: "['4000-5000']" }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 10).to eq(true)
      end

      it 'success multi filter' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1,
                              brand_ids: [brands_list.first.id].to_s,
                              prices: ['1000-1500'],
                              rating: 3,
                              order_by: 'DESC' }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 5).to eq(true)
      end

      it 'error multi filter' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1,
                              brand_ids: [brands_list.first.id],
                              rating: 4,
                              order_by: 'DESC' }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 0).to eq(true)
      end

      it 'success products empty stock 0' do
        ProductVariant.where.not(current_stock: 0).update(current_stock: 0)

        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1 }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 0).to eq(true)
      end

      it 'success products empty product inactive' do
        Product.where(active: true).update(active: false)

        request.headers['secret-api'] = ENV['SECRET_API']
        get :index, params: { category_id: root_category.id,
                              page: 1 }, as: :json

        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') == 0).to eq(true)
      end
    end
  end
end
