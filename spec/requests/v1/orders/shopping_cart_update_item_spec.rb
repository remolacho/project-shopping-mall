require 'swagger_helper'

RSpec.describe V1::Orders::ShoppingCartController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Busca y edita la cantidad de items al carrito de compras" do
    path "/v1/orders/shoppingCart/{order_item_id}" do
      put 'Orden de compra y sus items' do
        tags 'Zofri Shopping cart'
        description '<p>Edita la cantidad del item seleccionado<b> NOTA: EL Authorization de la cabecera puede ir o no ir ya que es para asociar
la orden a un user o no</b></p>'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_item_id, in: :path, required: true, type: :integer
        parameter name: :order_token, in: :query, required: true, type: :string
        parameter name: :order_item_body, in: :body, schema: {
          type: :object,
          properties: {
            order_item: {
              type: :object,
              properties: {item_qty: { type: :integer }}
            }
          },
          required: ['item_qty']
        }
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
                              order_items: {
                                  type: :array,
                                  items: {
                                      type: :object,
                                      properties: {
                                          id: { type: :integer },
                                          product_variant_id: { type: :integer },
                                          name: { type: :string },
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

          let(:order_token) {
            current_order.save
            current_order.token
          }

          let(:order_item_body) { { order_item: { item_qty: 2 } } }
          let(:order_item_id) { list_order_item.last.id }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:order_item_body) { { order_item: { item_qty: 2 } } }
          let(:order_token) { current_order.token }
          let(:order_item_id) { list_order_item.last.id }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Order Item error!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:order_item_body) { { order_item: { item_qty: 2 } } }
          let(:order_token) { current_order.token }
          let(:order_item_id) { 9999 }
          run_test!
        end

      end
    end
  end

end


