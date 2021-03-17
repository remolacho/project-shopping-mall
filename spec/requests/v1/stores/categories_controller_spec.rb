require 'swagger_helper'

RSpec.describe V1::Stores::CategoriesController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Busca las categorias padres que tienen productos para una tienda" do
    path "/v1/stores/categories/{store_id}" do
      get 'Obtiene la lista de tiendas' do
        tags 'Zofri Store'
        description "retorna la lista de categorias con la cantidad de productos que estan publicados en esa tienda"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :store_id, in: :path, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   categories: { type: :array,
                                 items: {
                                   type: :object,
                                   properties: {
                                     id: { type: :integer },
                                     name: { type: :string },
                                     slug: { type: :string },
                                     products_count: { type: :integer },
                                     is_visible: { type: :boolean },
                                   }
                                 } }
                 }

          let(:store_id) {
            products_category_child
            store.id
          }

          run_test! do |resp|
            body = JSON.parse(resp.body)
            total = products_category_child.size + products_category.size
            expect(body['categories'][0]['products_count']).to eq(total)
          end
        end
      end
    end
  end

  describe "Busca las categorias hijas que tienen productos para una tienda" do
    path "/v1/stores/categories/{store_id}/children/{category_id}" do
      get 'Obtiene la lista de tiendas' do
        tags 'Zofri Store'
        description "retorna la lista de categorias con la cantidad de productos que estan publicados en esa tienda para el area seleccionada"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :store_id, in: :path, required: false, type: :integer
        parameter name: :category_id, in: :path, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   categories: { type: :array,
                                 items: {
                                   type: :object,
                                   properties: {
                                     id: { type: :integer },
                                     name: { type: :string },
                                     slug: { type: :string },
                                     products_count: { type: :integer },
                                     is_visible: { type: :boolean },
                                   }
                                 } }
                 }

          let(:store_id) {
            store.id
          }

          let(:category_id) {
            products_category_child
            products_category_child_depth_3
            root_category.id
          }

          run_test! do |resp|
            body = JSON.parse(resp.body)
            total = products_category_child.size + products_category.size
            expect(body['categories'][0]['products_count']).to eq(total)
          end
        end
      end
    end
  end
end
