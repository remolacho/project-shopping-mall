require 'swagger_helper'

RSpec.describe V1::Orders::UserController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Crea el user data en la orden" do
    path "/v1/orders/userOrder/{order_token}" do
      get 'Muestra la orden del usuario logueado' do
        tags 'Zofri Orders'
        description '<p>Devuelve la data de la orden que pertenece a usuario logueado</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: true
        parameter name: :order_token, in: :path, required: true, type: :string

        response 200, 'success !!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   order: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       delivery_state: { type: :string },
                       number_ticket: { type: :string },
                       payment_state: { type: :string },
                       items_qty: { type: :integer },
                       token: { type: :string },
                       payment_total: { type: :number },
                       promotion_total: { type: :number },
                       created_at: { type: :string },
                       receive: { type: :object,
                                  properties: {
                                    name: { type: :string },
                                    last_name: { type: :string },
                                    email: { type: :string },
                                    phone: { type: :string }
                                  } },
                       shipment: { type: :object,
                                   properties: {
                                     value: { type: :string },
                                     state: { type: :string },
                                     method_name: { type: :string },
                                     method_type: { type: :string }
                                   } },
                       address: {
                         type: :object,
                         properties: {
                           street_number: { type: :string, nullable: true },
                           street: { type: :string, nullable: true },
                           condominium: { type: :string, nullable: true },
                           apartment_number: { type: :string, nullable: true },
                           comment: { type: :string, nullable: true }
                         }
                       },
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

          let(:'Authorization') {
            auth_bearer(current_user, {})
          }

          let(:order_token) {
            list_order_item_consolidate
            current_order.token
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(true)
            expect(body['order'].present?).to eq(true)
          end
        end

        response 404, 'not found, the order not belongs to user !!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') {
            auth_bearer(current_user_2, {})
          }

          let(:order_token) {
            current_order.token
          }

          run_test!
        end

        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }

          let(:order_token) {
            current_order.token
          }

          run_test!
        end
      end
    end
  end
end
