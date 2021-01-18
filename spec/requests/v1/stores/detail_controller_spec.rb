require 'swagger_helper'

RSpec.describe V1::Stores::DetailController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Busca la tienda y sus productos" do
    path "/v1/stores/detail/{store_id}" do
      get 'Obtiene la lista de tiendas' do
        tags 'Zofri Store'
        description "<p>Se devuelve la tienda activa mediante el id, esto devuelve tambien los
productos destacados y normales paginados en el query page_f hace referencia a la pagina de los
destacados y page de los productos normales asi puede ser paginado de forma independiente por
defecto es 1 para las dos si alguna no se envia siempre devolvera la primera</p>"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :store_id, in: :path, required: false, type: :integer
        parameter name: :page_f, in: :query, required: false, type: :integer
        parameter name: :page, in: :query, required: false, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   store: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       banner_url: { type: :string, nullable: true },
                       icon_url: { type: :string, nullable: true },
                       what_we_do: { type: :string, nullable: true },
                       facebook: { type: :string, nullable: true },
                       instagram: { type: :string, nullable: true },
                       twitter: { type: :string, nullable: true },
                       mall_location: { type: :string, nullable: true },
                       products: {
                         type: :object,
                         properties: {
                             per_page: { type: :integer, default: 12 },
                             total_pages: { type: :integer, default: 4 },
                             total_objects: { type: :integer, default: 40 },
                             list: {
                                 type: :array,
                                 items: {
                                     type: :object,
                                     properties: {
                                         id: { type: :integer },
                                         image_url: { type: :string, nullable: true },
                                         name: { type: :string },
                                         price: { type: :number },
                                         rating: { type: :number },
                                         featured: { type: :boolean }
                                       }
                                   }
                             }
                         }
                       },
                       products_featured: {
                           type: :object,
                           properties: {
                               per_page: { type: :integer, default: 12 },
                               total_pages: { type: :integer, default: 4 },
                               total_objects: { type: :integer, default: 40 },
                               list: {
                                   type: :array,
                                   items: {
                                       type: :object,
                                       properties: {
                                           id: { type: :integer },
                                           image_url: { type: :string, nullable: true },
                                           name: { type: :string },
                                           price: { type: :number },
                                           rating: { type: :number },
                                           featured: { type: :boolean }
                                       }
                                   }
                               }
                           }
                       }
                     }
                   }
                 }

          let(:store_id) {
            products_featured_category
            store.id
          }

          let(:page) { 2 }

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('store', 'products', 'current_page')).to eq(2)
            expect(body.dig('store', 'products', 'list').all?{ |item| !item['featured'] }).to eq(true)
            expect(body.dig('store', 'products_featured', 'current_page')).to eq(1)
            expect(body.dig('store', 'products_featured', 'list').all?{ |item| item['featured'] }).to eq(true)
          end

          let(:page) {
            Product.where(active: true).update(active: false)
            2
          }

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('store', 'products', 'list').size.zero?).to eq(true)
            expect(body.dig('store', 'products_featured', 'list').size.zero?).to eq(true)
          end

        end

        response 404, 'not found!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:store_id) { store_inactive.id }

          run_test!
        end

      end
    end
  end
end
