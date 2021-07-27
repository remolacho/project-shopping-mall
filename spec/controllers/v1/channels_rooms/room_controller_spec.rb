require 'rails_helper'

RSpec.describe V1::ChannelsRooms::RoomController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'stores_products_stuff'

  describe 'Creating a channel' do
    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
      request.headers['Authorization'] = auth_bearer(current_user, {})

      payment_method
      current_order.save
      list_order_item_consolidate

      ::Payment::Create.new(data: body).perform

    }

    let(:body) do
      {
        "id": 'approved',
        "live_mode": true,
        "type": 'payment',
        "date_created": '2015-03-25T10:04:58.396-04:00',
        "action": 'payment.created',
        "data_id": 'approved',
        "data": {
          "id": 'approved',
          "external_reference": current_order.token
        }
      }
    end

    context 'Validation' do
      it 'error store order not found!!!' do
        get :create, params: { created_by: 'seller', store_order_id: 9999 }
        expect(response.status).to eq(404)
      end

      it 'error store order is not active!!!' do
        store_order = StoreOrder.last
        store_order.state = StoreOrder::ON_PURCHASE
        store_order.save!

        get :create, params: { created_by: 'test', store_order_id: store_order.id }
        expect(response.status).to eq(404)
      end

      it 'error params created by, only allow seller or customer!!!' do
        get :create, params: { created_by: 'test', store_order_id: StoreOrder.last.id }
        expect(response.status).to eq(422)
      end

      it 'error the order has not user!!!' do
        store_order = StoreOrder.last
        store_order.order.update!(user_id: nil)

        get :create, params: { created_by: 'seller', store_order_id: store_order.id }
        expect(response.status).to eq(404)
      end
    end

    context 'opening room' do
      it 'the seller open room after customer' do
        get :create, params: { created_by: 'seller', store_order_id: StoreOrder.last.id }
        body_seller = JSON.parse(response.body)

        get :create, params: { created_by: 'customer', store_order_id: StoreOrder.last.id }
        body_customer = JSON.parse(response.body)

        expect(body_customer['room']['token']).to eq(body_seller['room']['token'])
        expect(response.status).to eq(200)
      end

      it 'the customer open room after seller' do
        get :create, params: { created_by: 'customer', store_order_id: StoreOrder.last.id }
        body_seller = JSON.parse(response.body)

        get :create, params: { created_by: 'seller', store_order_id: StoreOrder.last.id }
        body_customer = JSON.parse(response.body)

        expect(body_customer['room']['token']).to eq(body_seller['room']['token'])
        expect(response.status).to eq(200)
      end
    end
  end
end
