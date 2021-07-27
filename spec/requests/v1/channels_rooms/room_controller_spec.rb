require 'swagger_helper'

RSpec.describe V1::ChannelsRooms::RoomController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'stores_products_stuff'

  describe "Abre una comunicacion con la tienda o el comprador" do
    path "/v1/channelRooms/{store_order_id}/{created_by}/create" do
      get 'Crea la sala de comunicacion' do
        tags 'Zofri Channel Rooms'
        description "Crea la comunicacion entre los verdedores y el comprador este EP recibe un parametro llamado created_by
que es un string y puede ser seller o customer depende de quien quiera entrar a la sala o abrirla"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: true
        parameter name: :store_order_id, in: :path, required: true, type: :integer
        parameter name: :created_by, in: :path, required: true, type: :string
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   room: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       user: {  type: :object,
                                properties: {
                                  id: { type: :integer },
                                  name: { type: :string },
                                  lastname: { type: :string }
                                } },
                       store: {  type: :object,
                                 properties: {
                                   id: { type: :integer },
                                   name: { type: :string },
                                 } },
                       token: { type: :string },
                       active: { type: :boolean }
                     }
                   }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }

          let(:store_order_id) {
            payment_method
            current_order.save
            list_order_item_consolidate
            ::Payment::Create.new(data: { id: 'approved', type: 'payment', data_id: 'approved',
                                          data: { id: 'approved', external_reference: current_order.token } }).perform
            StoreOrder.last.id
          }

          let(:created_by) { 'seller' }

          run_test!
        end

        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:created_by) { 'seller' }
          let(:store_order_id) { 999 }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:'secret-api') { 'error secret' }
          let(:created_by) { 'seller' }
          let(:store_order_id) { 999 }

          run_test!
        end

        response 404, 'Not found store order!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:created_by) { 'seller' }
          let(:store_order_id) { 999 }

          run_test!
        end

        response 422, 'Argument created_by error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }

          let(:store_order_id) {
            payment_method
            current_order.save
            list_order_item_consolidate
            ::Payment::Create.new(data: { id: 'approved', type: 'payment', data_id: 'approved',
                                          data: { id: 'approved', external_reference: current_order.token } }).perform
            StoreOrder.last.id
          }

          let(:created_by) { 'test' }

          run_test!
        end
      end
    end
  end
end
