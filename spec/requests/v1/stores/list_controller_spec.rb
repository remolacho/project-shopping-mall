require 'swagger_helper'

RSpec.describe V1::Stores::ListController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Busca las tiendas segun filtro" do
    path "/v1/stores/list" do
      get 'Obtiene la lista de tiendas' do
        tags 'Zofri Productos'
        description "retorna la lista de tiendas y recibe filtro por categoria, por nombre y orden por nombre asc /desc
 ?category_id=&term=''&order_by=DESC&page=1</p>"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :category_id, in: :query, required: false, type: :integer
        parameter name: :term, in: :query, required: false, type: :string
        parameter name: :order_by, in: :query, required: false, type: :string
        parameter name: :page, in: :query, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   per_page: { type: :integer, default: 12 },
                   total_pages: { type: :integer, default: 4 },
                   total_objects: { type: :integer, default: 40 },
                   stores: { type: :array,
                             items: {
                               type: :object,
                               properties: {
                                 id: { type: :integer },
                                 banner_url: { type: :string, nullable: true },
                                 icon_url: { type: :string, nullable: true },
                                 name: { type: :string },
                                 mall_location: { type: :string },
                                 what_we_do: { type: :string },
                                 categories: {
                                   type: :array,
                                   items: {
                                     type: :object,
                                     properties: {
                                       id: { type: :integer },
                                       name: { type: :string },
                                       slug: { type: :string },
                                       count: { type: :integer }
                                     }
                                   }
                                 }
                               }
                             } }
                 }

          let(:category_id) { root_category.id }

          run_test!
        end
      end
    end
  end
end
