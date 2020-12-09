require 'swagger_helper'

RSpec.describe V1::Orders::ShoppingCartController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe "Busca crea o agrega item al carrito de compras" do
    path "/v1/orders/shoppingCart/addItem" do
      get 'Orden de compra y sus items' do
        tags 'Zofri Shopping cart'
        description '<p>crea o busca una orden obtiene sus items agregando o asignando cantidad en
caso de existir <b> NOTA: EL Authorization de la cabecera puede ir o no ir ya que es para asociar
la orden a un user o no</b></p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :query, required: false, type: :string
        parameter name: :product_variant_id, in: :query, required: true, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   order: { type: :object,
                            properties: {
                              id: { type: :integer },
                              token: { type: :string },
                              number_ticket: { type: :string },
                              payment_total: { type: :number },
                              state: { type: :string },
                              user_data: { type: :object,
                                           properties: {
                                               name: { type: :string },
                                               last_name: { type: :string },
                                               email: { type: :string },
                                               phone: { type: :string }
                                           }
                              },
                              order_items: {
                                type: :array,
                                items: {
                                    type: :object,
                                    properties: {
                                        id: { type: :integer },
                                        product_variant_id: { type: :integer },
                                        name: { type: :string },
                                        weight: { type: :number },
                                        height: { type: :number },
                                        width: { type: :number },
                                        length: { type: :number },
                                        image_url: { type: :string, nullable: true },
                                        unit_value: { type: :number},
                                        item_qty: { type: :integer },
                                        total: { type: :number }
                                      }
                                  }
                              }
                            }
                          }
                 }

          let(:product_variant_id) { products_category.last.product_variants.first.id }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:product_variant_id) { products_category.last.product_variants.first.id }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Item error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }
          let(:product_variant_id) { 9999 }
          run_test!
        end

      end
    end
  end

end
