require 'swagger_helper'

RSpec.describe V1::Products::DetailController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna data del user' do

    path "/v1/product/detail/{product_id}" do
      get 'Devuelve el detalle del producto con cada variante' do
        tags 'Zofri Productos'
        description '<p>Retorna el producto con cada variante precio de variante y opciones de variantes
mas sus imagenes por variante</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :product_id, in: :path
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean},
                   product: { type: :object,
                              properties: { id: { type: :integer },
                                            name: { type: :string },
                                            description: { type: :string, nullable: true },
                                            short_description: { type: :string },
                                            image_url: {type: :string, nullable: true },
                                            store: {
                                                type: :object,
                                                properties: {
                                                    id: { type: :integer },
                                                    name: { type: :string },
                                                }
                                            },
                                            variants: {
                                                type: :array,
                                                items: {
                                                    type: :object,
                                                    properties: {
                                                        name: { type: :string },
                                                        short_description: { type: :string },
                                                        weight: { type: :number },
                                                        width: { type: :number },
                                                        height: { type: :number },
                                                        length: { type: :number },
                                                        is_master: { type: :boolean },
                                                        price: { type: :number },
                                                        current_stock: { type: :integer},
                                                        images_urls: {
                                                            type: :array,
                                                            items: {}
                                                          },
                                                        option_variants: {
                                                            type: :array,
                                                            items: {
                                                                type: :object,
                                                                properties: {
                                                                    id: { type: :integer },
                                                                    type: { type: :string },
                                                                    value: { type: :string },
                                                                  }
                                                              }
                                                          },
                                                      }
                                                  }
                                              }}
                     }
                 }

          let(:product_id) { Product.last.id }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }
          let(:product_id) { Product.last.id }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'product api error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }
          let(:product_id) { 9999 }
          run_test!
        end

      end
    end
  end
end


