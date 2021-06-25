require 'rails_helper'

RSpec.describe V1::Orders::ShoppingCartController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'shipment_stuff'

  describe 'Put#update' do

    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
      request.headers['Authorization'] = auth_bearer(current_user, {})
    }

    it 'returns success false token state is not ON_PURCHASE' do
      current_order.state = Order::IS_COMPLETED
      current_order.save
      item_id = list_order_item.last.id
      put :update, params: {order_token: current_order.token,
                             order_item_id: item_id,
                             order_item: {item_qty: 2}}

      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
    end

    it 'returns success false quantity is string' do
      current_order.save
      item_id = list_order_item.last.id
      put :update, params: {order_token: current_order.token,
                            order_item_id: item_id,
                            order_item: { item_qty: 'test' } }

      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
    end

    it 'returns success false quantity is nil' do
      current_order.save
      item_id = list_order_item.last.id
      put :update, params: {order_token: current_order.token,
                            order_item_id: item_id,
                            order_item: {} }

      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
    end

    it 'returns success false quantity is nil' do
      current_order.save
      item_id = list_order_item.last.id
      put :update, params: {order_token: current_order.token,
                            order_item_id: item_id}

      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
    end

    it 'returns success and remove item, item_qty is 0' do
      current_order.save
      item_id = list_order_item.last.id
      current_order.consolidate_payment_total

      put :update, params: {order_token: current_order.token,
                            order_item_id: item_id,
                            order_item: { item_qty: 0 } }

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['number_ticket']).to eq(current_order.number_ticket)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(list_order_item.size == 3).to eq(true)
      expect(order['order_items'].size == 2).to eq(true)
      expect(order['order_items'].detect{|item| item['id'] == item_id }.present?).to eq(false)
      expect(list_order_item.detect{|item| item.id == item_id }.present?).to eq(true)
      expect(current_order.payment_total > order['payment_total']).to eq(true)
    end

    it 'returns success add 1 quantity' do
      current_order.save
      _item = list_order_item.last
      current_order.consolidate_payment_total

      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 2 } }

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['number_ticket']).to eq(current_order.number_ticket)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(list_order_item.size == 3).to eq(true)
      expect(order['order_items'].size == 3).to eq(true)
      expect(order['order_items'].detect{|item| item['id'] == _item.id }.present?).to eq(true)
      expect(current_order.payment_total < order['payment_total']).to eq(true)
      expect(_item.item_qty < order['payment_total']).to eq(true)
      expect(_item.item_qty < order['order_items'].detect{|item| item['id'] == _item.id }['item_qty']).to eq(true)
    end

    it 'returns success remove 1 quantity' do
      current_order.save
      item_id = list_order_item.last.id
      _item = OrderItem.find(item_id)
      _item.item_qty = 2
      _item.save
      current_order.consolidate_payment_total
      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 1 } }

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['number_ticket']).to eq(current_order.number_ticket)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size == 3).to eq(true)
      expect(order['order_items'].detect{|item| item['id'] == _item.id }.present?).to eq(true)

      new_item = order['order_items'].detect{|item| item['id'] == item_id }
      expect(_item.id == new_item['id'].to_i).to eq(true)
      expect(_item.item_qty == 2).to eq(true)
      expect(new_item['item_qty'] == 1).to eq(true)
      expect(current_order.payment_total > order['payment_total']).to eq(true)

    end

    it 'success add +1 consolidate promotion' do
      promotion_adjustment
      _item = list_order_item_consolidate.last
      current_order.consolidate_payment_total

      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 2 } }

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['promotion_total'] < promotion_adjustment.value).to eq(true)
    end

    it 'success remove -1 consolidate promotion' do
      promotion_adjustment
      _item = list_order_item_consolidate.last
      current_order.consolidate_payment_total

      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 0 } }

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['promotion_total'] > promotion_adjustment.value).to eq(true)
    end

    it 'success remove -1 consolidate shipment' do
      shipment_cost

      _item = list_order_item_consolidate.last

      Orders::CreateShipment.new(order: current_order, data: shipment_data_delivey[:shipment]).perform

      current_order.reload
      expect(current_order.shipment_total > 0).to eq(true)
      expect(current_order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
      expect(current_order.shipment.present?).to eq(true)

      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 0 } }

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['shipment_total'].zero?).to eq(true)
      expect(current_order.reload.shipment.nil?).to eq(true)
    end

    it 'success add +1 consolidate shipment' do
      shipment_cost

      _item = list_order_item_consolidate.last
      Orders::CreateShipment.new(order: current_order, data: shipment_data_delivey[:shipment]).perform

      current_order.reload
      expect(current_order.shipment_total > 0).to eq(true)
      expect(current_order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
      expect(current_order.shipment.present?).to eq(true)

      put :update, params: {order_token: current_order.token,
                            order_item_id: _item.id,
                            order_item: { item_qty: 2 } }

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['shipment_total'].zero?).to eq(true)
      expect(current_order.reload.shipment.nil?).to eq(true)
    end

  end
end


