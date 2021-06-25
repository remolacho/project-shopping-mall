# frozen_string_literal: true
require 'rails_helper'

RSpec.describe V1::Orders::PaymentController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'
  include_context 'stores_products_stuff'

  describe 'GET #gateway' do
    let(:body) do
      {
        "id": 'approved',
        "live_mode": true,
        "type": 'payment',
        "date_created": '2015-03-25T10:04:58.396-04:00',
        "action": 'payment.created',
        "data.id": 'approved',
        "data": {
          "id": 'approved',
          "external_reference": current_order.token
        }
      }
    end

    it 'returns error logger' do
      current_order.save
      list_order_item_consolidate

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)
      expect(current_order.stock_movements.size.zero?).to eq(false)

      body[:data].merge!(external_reference: 'no valid')
      post :create, params: body
      expect(LoggersErrorPayment.all.size.zero?).to eq(false)
      expect(response.status).to eq(404)
    end

    it 'returns error logger the payment was previously approved' do
      current_order.payment_state = Payment::APPROVED
      current_order.save
      list_order_item_consolidate
      current_order.payments.create!(payment_logs: {},
                                     total: current_order.payment_total,
                                     state: Payment::APPROVED,
                                     payment_method_id: payment_method.id)

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)
      expect(current_order.stock_movements.size.zero?).to eq(false)

      post :create, params: body
      expect(LoggersErrorPayment.all.size.zero?).to eq(false)
      expect(response.status).to eq(404)
    end

    it 'returns success  approved' do
      payment_method

      current_order.user_data = {
          email: create_user.email,
          name: create_user.name,
          last_name: create_user.lastname,
          phone: '55555555'
      }

      current_order.save

      products_list
      list_order_item_many_stores

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)
      expect(current_order.stock_movements.size.zero?).to eq(false)
      expect(current_order.state.eql?(Order::ON_PURCHASE)).to eq(true)
      expect(current_order.store_orders.size.zero?).to eq(true)

      post :create, params: body

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      store_orders = order.store_orders

      expect(response).to have_http_status(:success)
      expect(order.state.eql?(Order::IS_COMPLETED)).to eq(true)
      expect(order.payment_state.eql?(Payment::APPROVED)).to eq(true)
      expect(order.payments.present?).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::APPROVED)}).to eq(true)
      expect(store_orders.size.zero?).to eq(false)
      expect(store_orders.all?{|so| so.state.eql?(Order::IS_COMPLETED)}).to eq(true)
      expect(store_orders.all?{|so| so.payment_state.eql?(Payment::APPROVED)}).to eq(true)
      expect(store_orders.all?{|so| so.order_items.present? }).to eq(true)
      expect(store_orders.all?{|so| so.payment_total > 0 }).to eq(true)
      expect(store_orders.map{|so| so.order_items.size }.sum == order.order_items.size).to eq(true)
      expect(order.delivery_state).to eq(Order::PENDING_DELIVERY)
    end

    it 'returns success in_process' do
      payment_method
      current_order.save
      list_order_item_consolidate

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)

      body[:data].merge!(id: 'in_process')
      post :create, params: body

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      expect(response).to have_http_status(:success)
      expect(order.stock_movements.size.zero?).to eq(false)
      expect(order.state.eql?(Order::ON_PURCHASE)).to eq(true)
      expect(order.store_orders.size.zero?).to eq(true)
      expect(order.payment_state.eql?(Payment::IN_PROCESS)).to eq(true)
      expect(order.payments.present?).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::IN_PROCESS)}).to eq(true)
      expect(order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
    end

    it 'returns success rejected' do
      payment_method
      current_order.save
      list_order_item_consolidate

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)
      expect(current_order.stock_movements.size.zero?).to eq(false)
      expect(current_order.state.eql?(Order::ON_PURCHASE)).to eq(true)

      body[:data].merge!(id: 'rejected')
      post :create, params: body

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      expect(response).to have_http_status(:success)
      expect(order.stock_movements.size.zero?).to eq(true)
      expect(order.state.eql?(Order::ON_PURCHASE)).to eq(true)
      expect(order.store_orders.size.zero?).to eq(true)
      expect(order.payment_state.eql?(Payment::REJECTED)).to eq(true)
      expect(order.payments.present?).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::REJECTED)}).to eq(true)

      variants = ProductVariant.where(id: list_order_item_consolidate.map(&:product_variant_id))
      result = variants.all?{ |variant| variant.stock_movements.sum(&:quantity) == variant.current_stock }
      expect(result).to eq(true)
      expect(order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
    end

    it 'returns success cancelled' do
      payment_method
      current_order.save
      list_order_item_consolidate

      check = ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      expect(check[:state]).to eq(200)
      expect(current_order.stock_movements.size.zero?).to eq(false)
      expect(current_order.state.eql?(Order::ON_PURCHASE)).to eq(true)

      body[:data].merge!(id: 'cancelled')
      post :create, params: body

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      expect(response).to have_http_status(:success)
      expect(order.stock_movements.size.zero?).to eq(true)
      expect(order.state.eql?(Order::ON_PURCHASE)).to eq(true)
      expect(order.store_orders.size.zero?).to eq(true)
      expect(order.payment_state.eql?(Payment::CANCELLED)).to eq(true)
      expect(order.payments.present?).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::CANCELLED)}).to eq(true)

      variants = ProductVariant.where(id: list_order_item_consolidate.map(&:product_variant_id))
      result = variants.all?{ |variant| variant.stock_movements.sum(&:quantity) == variant.current_stock }
      expect(result).to eq(true)
      expect(order.delivery_state).to eq(Order::UNSTARTED_DELIVERY)
    end

    it 'returns success refunded with payment approved' do
      payment_method
      current_order.save
      list_order_item_consolidate

      ::ShoppingCart::Check.new(user: nil, order: current_order).perform
      ::Payment::Create.new(data: body).perform

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      store_orders = order.store_orders

      expect(order.state.eql?(Order::IS_COMPLETED)).to eq(true)
      expect(order.payment_state.eql?(Payment::APPROVED)).to eq(true)
      expect(order.stock_movements.size.zero?).to eq(false)
      expect(store_orders.size.zero?).to eq(false)
      expect(LoggersErrorPayment.all.size.zero?).to eq(false)

      body[:data].merge!(id: 'refunded')
      post :create, params: body

      order = Order.includes(:store_orders, :payments).find(current_order.id)
      # store_orders = order.store_orders

      expect(response).to have_http_status(:success)
      expect(order.payments.present?).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::APPROVED)}).to eq(true)
      expect(order.payments.any?{|p| p.state.eql?(Payment::REFUNDED)}).to eq(true)
      expect(order.payment_state.eql?(Payment::REFUNDED)).to eq(true)
      expect(order.state.eql?(Order::IS_CANCELED)).to eq(true)
      expect(order.delivery_state).to eq(Order::CANCELED_DELIVERY)
    end

  end
end
