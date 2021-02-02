require 'rails_helper'

RSpec.describe V1::Products::ListController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'list products by attribute' do
    context '#discount' do
      it 'success list empty' do
        request.headers['secret-api'] = ENV['SECRET_API']
        get :discount, params: { page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').empty?).to eq(true)
        expect(response.status).to eq(200)
      end

      it 'success list' do
        request.headers['secret-api'] = ENV['SECRET_API']

        product = products_category.last
        variant = product.product_variants.last
        variant.discount_value = 700
        variant.save

        get :discount, params: { page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('products').empty?).to eq(false)
        expect(response.status).to eq(200)
      end

      it 'success all hierarchy categories skip other category!!!' do
        request.headers['secret-api'] = ENV['SECRET_API']
        total_product = (products_category.size + products_category_child.size + products_category_child_depth_3.size)

        product = products_category.last
        variant = product.product_variants.last
        variant.discount_value = 700
        variant.save

        product = products_category_child_depth_3.last
        variant = product.product_variants.last
        variant.discount_value = 999
        variant.save

        product = products_category_2.last
        variant = product.product_variants.last
        variant.discount_value = 2000
        variant.save

        get :discount, params: { category_id: root_category.id, page: 1 }, as: :json
        body = JSON.parse(response.body)
        expect(body.dig('success')).to eq(true)
        expect(body.dig('total_objects') < total_product).to eq(true)
        expect(body.dig('total_objects')).to eq(2) # 2 productos en toda la jerarquia se les da descuento
      end
    end
  end
end
