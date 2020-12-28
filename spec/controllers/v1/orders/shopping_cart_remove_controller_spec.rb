require 'rails_helper'

RSpec.describe V1::Orders::ShoppingCartController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe 'Delete#delete' do

    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
      request.headers['Authorization'] = auth_bearer(current_user, {})
    }

    it 'returns success false token state is not ON_PURCHASE' do
      current_order.state = Order::IS_COMPLETED
      current_order.save
      delete_item_id = list_order_item.last.id
      delete :destroy, params: {order_token: current_order.token, order_item_id: delete_item_id}

      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
    end

    it 'returns success' do
      current_order.save
      delete_item_id = list_order_item.last.id
      current_order.consolidate_payment_total

      delete :destroy, params: {order_token: current_order.token, order_item_id: delete_item_id}

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['number_ticket']).to eq(current_order.number_ticket)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(list_order_item.size == 3).to eq(true)
      expect(order['order_items'].size == 2).to eq(true)
      expect(order['order_items'].detect{|item| item['id'] == delete_item_id }.present?).to eq(false)
      expect(list_order_item.detect{|item| item.id == delete_item_id }.present?).to eq(true)
      expect(current_order.payment_total > order['payment_total']).to eq(true)
    end

    it 'success consolidate promotion' do
      promotion_adjustment
      delete_item_id = list_order_item_consolidate.last.id
      current_order.consolidate_payment_total

      delete :destroy, params: {order_token: current_order.token, order_item_id: delete_item_id}

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['promotion_total'] > promotion_adjustment.value).to eq(true)
    end

    it 'success consolidate shipment' do
      delete_item_id = list_order_item_consolidate.last.id
      Orders::CreateShipment.new(order: current_order, data: shipment_data_delivey[:shipment]).perform

      current_order.reload
      expect(current_order.shipment_total > 0).to eq(true)
      expect(current_order.delivery_state).to eq(Shipment::PENDING)
      expect(current_order.shipment.present?).to eq(true)

      delete :destroy, params: {order_token: current_order.token, order_item_id: delete_item_id}

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['shipment_total'].zero?).to eq(true)
      expect(current_order.reload.shipment.nil?).to eq(true)
    end

  end
end

