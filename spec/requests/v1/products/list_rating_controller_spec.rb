require 'swagger_helper'

RSpec.describe V1::Products::ListController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de productos por rating y filtro de categoria' do
    path "/v1/products/rating/list" do
      get 'Lista de productos por rating' do
        tags 'Zofri Productos'
        description "retorna la lista de productos con rating paginado y por filtro de categoria <p>ordenado por rating y precio Qyery ?page=1&category_id=xxx</p>"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :category_id, in: :query, required: false, type: :integer
        parameter name: :page, in: :query, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   per_page: { type: :integer, default: 12 },
                   current_page: { type: :integer, default: 1 },
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
                                   discount_price: { type: :number },
                                   rating: { type: :number },
                                   image_url: { type: :string, nullable: true },
                                   brand_name: { type: :string },
                                 }
                               } }
                 }

          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'secret-api') { 'error secret' }
          run_test!
        end
      end
    end
  end
end
