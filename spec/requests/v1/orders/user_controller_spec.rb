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
          required: ['name', 'lastname',  'email', 'phone']
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
                               }}

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          let(:user_data){
            {user: {
                email: create_user.email,
                name: create_user.name,
                last_name: create_user.lastname,
                phone: '55555555'
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

          let(:user_data){
            {user: {
                email: create_user.email,
                name: create_user.name,
                last_name: create_user.lastname,
                phone: '55555555'
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

          let(:user_data){
            {user: {
                email: create_user.email,
                name: create_user.name,
                last_name: create_user.lastname,
                phone: '55555555'
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

          let(:user_data){
            {user: {
                email: '',
                name: create_user.name,
                last_name: create_user.lastname,
                phone: '55555555'
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

