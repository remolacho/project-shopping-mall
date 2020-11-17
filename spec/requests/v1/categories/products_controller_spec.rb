require 'swagger_helper'

RSpec.describe V1::Categories::ProductsController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de productos por categoria' do

    path "/v1/category/{category_id}/products" do
      get 'Lista de productos' do
        tags 'Zofri Productos'
        description "retorna la lista de productos por categoria, en su filtro puede estar por rango de precio,
<p>ordenado por precio asc o desc, marca, calificacion Qyery ?prices=['1000-2000', '2000-5000']&brand_ids=[1, 2, 3]&order_by=DESC&rating=3</p>"
        produces 'application/json'
        parameter name: 'secret-api', in: :header
        parameter name: :category_id, in: :path
        parameter name: :brand_ids, in: :query, required: false, type: :string
        parameter name: :prices, in: :query, required: false, type: :string
        parameter name: :order_by, in: :query, required: false, type: :string
        parameter name: :rating, in: :query, required: false, type: :integer
        parameter name: :page, in: :query, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                     success: { type: :boolean },
                     per_page: { type: :integer, default: 12 },
                     total_pages: { type: :integer, default: 4 },
                     total_objects: { type: :integer, default: 40 },
                     products: { type: :array,
                                 items: {
                                     type: :object,
                                     properties: {
                                         id: { type: :integer },
                                         name: { type: :string },
                                         category_name: { type: :string },
                                         short_description: { type: :string },
                                         price: { type: :number },
                                         rating: { type: :number },
                                         image_url: { type: :string, nullable: true },
                                         brand_name: { type: :string },
                                     }
                                 }
                     }
                 }

          let(:category_id) { root_category.id }

          run_test!
        end

        response 404, 'Error data no encontrada' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:category_id) { 9999 }
          run_test!
        end
      end
    end
  end
end


