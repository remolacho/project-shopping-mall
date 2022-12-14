require 'swagger_helper'

RSpec.describe V1::Orders::CompletedController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Retorna una orden completa" do
    path "/v1/orders/completed/{order_token}" do
      get 'Orden de compra completa y sus items' do
        tags 'Zofri Shopping cart'
        description '<p>Lista todos los items y sus cantidaedes totales de una orden completada <b> NOTA: EL Authorization de la cabecera puede ir o no ir ya que es para asociar
la orden a un user o no</b></p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :path, required: true, type: :string
        
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
                                  has_shipment: { type: :boolean },
                                  promotion_total: { type: :number },
                                  user_data: { type: :object,
                                               properties: {
                                                   name: { type: :string },
                                                   last_name: { type: :string },
                                                   email: { type: :string },
                                                   phone: { type: :string }
                                               }
                                  },
                                  address: {
                                      type: :object,
                                      properties: {
                                          street_number: {type: :string, nullable: true },
                                          street: {type: :string, nullable: true },
                                          condominium: {type: :string, nullable: true },
                                          apartment_number: {type: :string, nullable: true },
                                          comment: {type: :string, nullable: true },
                                      }
                                  },
                                  commune: {
                                      type: :object,
                                      properties: {
                                          id: {type: :integer, nullable: true },
                                          name: {type: :string, nullable: true }
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

          let(:order_token) {
            current_order.state = Order::IS_COMPLETED
            current_order.save
            list_order_item
            current_order.token
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('order').key?('address')).to eq(true)
          end
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:order_token) { 
            current_order.state = Order::IS_COMPLETED
            current_order.token 
          }
          let(:'secret-api') { 'error secret' }
          
          run_test!
        end

        response 404, 'Order token error!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:order_token) { 'test error' }
          run_test!

          let(:order_token) {
            current_order.save
            current_order.token
          }

          run_test!
        end


      end
    end
  end

end



