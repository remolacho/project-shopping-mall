require 'swagger_helper'

RSpec.describe V1::Orders::UserController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Crea el user data en la orden" do
    path "/v1/orders/{order_token}/user" do
      post 'Guardar datos del usuario' do
        tags 'Zofri Orders'
        description '<p>Envia la data del user para ser almacenada en la orden</p>'
        produces 'application/json'
        consumes 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :path, required: true, type: :string
        parameter name: :user_data, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                name: { type: :string },
                last_name: { type: :string },
                phone: { type: :string }
              }
            }
          },
          required: ['name', 'lastname', 'email', 'phone']
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: { success: { type: :boolean },
                               user: {
                                 type: :object,
                                 properties: {
                                   email: { type: :string },
                                   name: { type: :string },
                                   lastname: { type: :string },
                                   phone: { type: :string }
                                 }
                               } }

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          let(:user_data) {
            { user: {
              email: create_user.email,
              name: create_user.name,
              last_name: create_user.lastname,
              phone: '55555555'
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

          let(:user_data) {
            { user: {
              email: create_user.email,
              name: create_user.name,
              last_name: create_user.lastname,
              phone: '55555555'
            } }
          }

          let(:order_token) { current_order.token }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Order token error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:user_data) {
            { user: {
              email: create_user.email,
              name: create_user.name,
              last_name: create_user.lastname,
              phone: '55555555'
            } }
          }

          let(:order_token) { 'testerror' }
          run_test!
        end

        response 422, 'Campo vacio!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:user_data) {
            { user: {
              email: '',
              name: create_user.name,
              last_name: create_user.lastname,
              phone: '55555555'
            } }
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

  describe "Lista de ordenes por usuario" do
    path "/v1/orders/listUser" do
      get 'Devuelve la lista de ordenes que tiene un usuario' do
        tags 'Zofri Orders'
        description '<p>Es el listado de ordenes que posee el usuario logueado</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: true

        skip "It must return the order avoiding listing those with => delivery_state: 'unstarted'" do 
          response 200, 'Success!!!' do
            schema type: :object,
                   properties: {
                     success: { type: :boolean, default: false },
                     orders: {
                       type: :array,
                       items: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           delivery_state: { type: :string },
                           number_ticket: { type: :string },
                           payment_state: { type: :string },
                           items_qty: { type: :integer },
                           token: { type: :string },
                           products: { type: :array, items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               name: { type: :string },
                               image_url: { type: :string, nullable: true },
                               unit_value: { type: :number },
                               total: { type: :number },
                               item_qty: { type: :integer }
                             }
                           } }
                         }
                       }
                     }
                   }
  
            let(:'Authorization') {
              list_order_item_consolidate
              auth_bearer(current_user, {})
            }
  
            run_test! do |response|
              body = JSON.parse(response.body)
              return_order = body['orders'].detect{|o| o['id'] == current_order.id}
              expect(return_order['products'].size == 2).to eq(true)
              expect( current_order.order_items.size > return_order['products'].size).to eq(true)
            end
          end
        end

        response 404, 'Not found!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') {
            list_order_item_consolidate
            auth_bearer(current_user_2, {})
          }

          run_test!
        end

        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }
          run_test!
        end
      end
    end
  end
end
