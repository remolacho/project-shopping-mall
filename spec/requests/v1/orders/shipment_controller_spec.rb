require 'swagger_helper'

RSpec.describe V1::Orders::ShipmentController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Crea la direccion y el envio en la orden" do
    path "/v1/orders/{order_token}/shipment" do
      post 'Guardar datos de la direccion y el shipment' do
        tags 'Zofri Orders'
        description '<p>Envia la data de la direccion para ser almacenada en la orden</p>'
        produces 'application/json'
        consumes 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :path, required: true, type: :string
        parameter name: :shipment_data, in: :body, schema: {
          type: :object,
          properties: {
            shipment: {
              type: :object,
              properties: {
              commune_id: { type: :integer },
              shipment_id: { type: :integer },
              delivery_price: { type: :number },
              firstname: { type: :string },
              lastname: { type: :string },
              apartment_number: { type: :string },
              condominium: { type: :string },
              street: { type: :string },
              street_number: { type: :string },
              comment: { type: :string },
              latitude: { type: :number },
              longitude: { type: :number }
            }
            }
          },
          required: ['name', 'lastname',  'email', 'phone']
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: { success: { type: :boolean },
                               order: { type: :object,
                                        properties: {
                                            id: { type: :integer },
                                            token: { type: :string },
                                            number_ticket: { type: :string },
                                            payment_total: { type: :number },
                                            state: { type: :string },
                                            has_shipment: { type: :boolean },
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
                                                        total: { type: :number },
                                                    }
                                                }
                                            }
                                        }
                               }
                 }

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          let(:shipment_data){
            {shipment: {
              commune_id: commune.id,
              shipment_id: shipment_method.id,
              in_site: false,
              delivery_price: 2500,
              latitude: 0,
              longitude: 0,
              apartment_number: '',
              condominium: '',
              street: 'test street',
              street_number: '2568',
              comment: 'es una prueba de direccion'
            }}
          }

          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:shipment_data){
            {shipment: {
              commune_id: commune.id,
              shipment_id: shipment_method.id,
              in_site: false,
              delivery_price: 2500,
              latitude: 0,
              longitude: 0,
              apartment_number: '',
              condominium: '',
              street: 'test street',
              street_number: '2568',
              comment: 'es una prueba de direccion'
            }}
          }

          let(:order_token) { current_order.token }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Order token error!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:shipment_data){
            {shipment: {
              commune_id: commune.id,
              shipment_id: shipment_method.id,
              in_site: false,
              delivery_price: 2500,
              latitude: 0,
              longitude: 0,
              apartment_number: '',
              condominium: '',
              street: 'test street',
              street_number: '2568',
              comment: 'es una prueba de direccion'
            }}
          }

          let(:order_token) { 'testerror' }
          run_test!
        end

        response 422, 'Campo vacio!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:shipment_data){
            {shipment: {
              commune_id: commune.id,
              shipment_id: shipment_method.id,
              in_site: false,
              delivery_price: 2500,
              latitude: 0,
              longitude: 0,
              apartment_number: '',
              condominium: '',
              street: '',
              street_number: '2568',
              comment: 'es una prueba de direccion'
            }}
          }

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          run_test!
        end
      end
    end
  end
end
