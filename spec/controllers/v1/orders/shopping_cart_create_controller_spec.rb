require 'rails_helper'

RSpec.describe V1::Orders::ShoppingCartController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'shipment_stuff'

  describe 'Post#gateway' do
    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
      request.headers['Authorization'] = auth_bearer(current_user, {})
    }

    let(:product_variant_id) { products_category.last.product_variants.first.id }

    it 'success creating order has user' do
      expect(Order.all.count.zero?).to eq(true)
      get :create, params: {product_variant_id: product_variant_id}
      expect(Order.all.count.zero?).to eq(false)
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['user_id'].present?).to eq(true)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size.zero?).to eq(false)
      expect(order['order_items'][0]['item_qty']).to eq(1)
    end

    it 'success creating order has user with discount_value' do
      discount_value = 800
      product_variant = ProductVariant.where(id: product_variant_id).update(discount_value: discount_value)[0]

      expect(Order.all.count.zero?).to eq(true)
      get :create, params: {product_variant_id: product_variant_id}
      expect(Order.all.count.zero?).to eq(false)
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['user_id'].present?).to eq(true)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size.zero?).to eq(false)
      expect(order['order_items'][0]['item_qty']).to eq(1)
      expect(order['order_items'][0]['unit_value'] == discount_value).to eq(true)
      expect(order['order_items'][0]['unit_value'] < product_variant.price ).to eq(true)
    end


    it 'success creating order has not user' do
      request.headers['Authorization'] = ''
      expect(Order.all.count.zero?).to eq(true)
      get :create, params: {product_variant_id: product_variant_id}
      expect(Order.all.count.zero?).to eq(false)
      expect(response.status).to eq(200)

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['user_id'].present?).to eq(false)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size.zero?).to eq(false)
      expect(order['order_items'][0]['item_qty']).to eq(1)
    end

    it 'returns success with order created' do
      expect(current_order.order_items.count.zero?).to eq(true)

      get :create, params: {order_token: current_order.token, product_variant_id: product_variant_id}

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size == 1).to eq(true)
      expect(order['order_items'][0]['item_qty']).to eq(1)
    end

    it 'returns success with order created' do
      expect(current_order.order_items.count.zero?).to eq(true)

      get :create, params: {order_token: current_order.token, product_variant_id: product_variant_id}

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size == 1).to eq(true)
      expect(order['order_items'][0]['item_qty']).to eq(1)
    end

    it 'returns success with order created state completed' do
      old_order = current_order
      old_order.state = Order::IS_COMPLETED
      old_order.save

      expect(old_order.state).to eq(Order::IS_COMPLETED)

      get :create, params: {order_token: old_order.token, product_variant_id: product_variant_id}

      body = JSON.parse(response.body)
      new_order = body['order']
      expect(new_order['id']).not_to eq(old_order.id)
      expect(new_order['order_token']).not_to eq(old_order.token)
      expect(new_order['order_token']).not_to eq(old_order.token)
      expect(new_order['state']).to eq(Order::ON_PURCHASE)
      expect(new_order['order_items'].size == 1).to eq(true)
      expect(new_order['order_items'][0]['item_qty']).to eq(1)
    end

    it 'returns success with order created and product_variant' do
      current_order.save
      product_variant = list_order_item.last.product_variant

      get :create, params: {order_token: current_order.token, product_variant_id: product_variant.id}

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['id']).to eq(current_order.id)
      expect(order['order_token']).to eq(current_order.token)
      expect(order['number_ticket']).to eq(current_order.number_ticket)
      expect(order['state']).to eq(Order::ON_PURCHASE)
      expect(order['order_items'].size > 1).to eq(true)
      expect(order['payment_total'] > 0.0).to eq(true)

      current_item = order['order_items'].detect{|item| item['product_variant_id'] == product_variant.id }
      expect(current_item['item_qty']).to eq(2)
      expect(current_item['total']).to eq((product_variant.price * 2).to_f)
    end

    it 'success consolidate promotion' do
      promotion_adjustment
      product_variant = list_order_item_consolidate.last.product_variant
      current_order.consolidate_payment_total

      get :create, params: {order_token: current_order.token, product_variant_id: product_variant.id}

      body = JSON.parse(response.body)
      order = body['order']

      expect(order['promotion_total'] < promotion_adjustment.value).to eq(true)
    end

    it 'success consolidate shipment' do
      shipment_cost

      product_variant = list_order_item_consolidate.last.product_variant
      Orders::CreateShipment.new(order: current_order, data: shipment_data_delivey[:shipment]).perform

      current_order.reload
      expect(current_order.shipment_total > 0).to eq(true)
      expect(current_order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
      expect(current_order.shipment.present?).to eq(true)

      get :create, params: {order_token: current_order.token, product_variant_id: product_variant.id}

      body = JSON.parse(response.body)
      order = body['order']
      expect(order['shipment_total'].zero?).to eq(true)
      expect(current_order.reload.shipment.nil?).to eq(true)
    end

  end
end
