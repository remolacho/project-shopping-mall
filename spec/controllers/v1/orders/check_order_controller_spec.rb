require 'rails_helper'

RSpec.describe V1::Orders::CheckOrderController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "GET #show" do
    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
    }

    it 'success there are errors in price' do
      item = list_order_item.last
      product_variant = item.product_variant
      product_variant.price = 9999
      product_variant.save
      get :show, params: { order_token: current_order.token }
      body = JSON.parse(response.body)
      expect(response.status).to eq(203)
      expect(body['items_errors'].present?).to eq(true)
    end

    it 'success there are errors in price, there is discount' do
      item = list_order_item.last
      product_variant = item.product_variant
      product_variant.discount_value = 800
      product_variant.save
      get :show, params: { order_token: current_order.token }
      body = JSON.parse(response.body)
      expect(response.status).to eq(203)
      expect(body['items_errors'].present?).to eq(true)
    end

    it 'success there are errors in discount' do
      item = list_order_item_with_discount.last
      product_variant = item.product_variant
      product_variant.discount_value = 0.0
      product_variant.save
      get :show, params: { order_token: current_order.token }
      body = JSON.parse(response.body)
      expect(response.status).to eq(203)
      expect(body['items_errors'].present?).to eq(true)
    end

    it 'success with stock_movements' do
      list_order_item
      get :show, params: { order_token: current_order.token }
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size.zero?).to eq(false)
      expect(stock_movements.all? { |movement| movement.quantity < 0 }).to eq(true)

      variants = ProductVariant.where(id: list_order_item.map(&:product_variant_id))
      result = variants.all? { |variant| variant.stock_movements.sum(&:quantity) == variant.current_stock }
      expect(result).to eq(true)
    end

    it 'success with stock_movements and discount' do
      list_order_item_with_discount

      get :show, params: { order_token: current_order.token }
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size.zero?).to eq(false)
      expect(stock_movements.all? { |movement| movement.quantity < 0 }).to eq(true)

      variants = ProductVariant.where(id: list_order_item_with_discount.map(&:product_variant_id))
      result = variants.all? { |variant| variant.stock_movements.sum(&:quantity) == variant.current_stock }
      expect(result).to eq(true)
    end

    it 'the user repeat the order check and not duplicate stock negative' do
      list_order_item
      get :show, params: { order_token: current_order.token }
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size == list_order_item.size).to eq(true)
      expect(stock_movements.all? { |movement| movement.quantity < 0 }).to eq(true)

      get :show, params: { order_token: current_order.token }
      stock_movements = StockMovement.where(order_id: current_order.id)
      expect(stock_movements.size == list_order_item.size).to eq(true)
      expect(stock_movements.all? { |movement| movement.quantity < 0 }).to eq(true)

      variants = ProductVariant.where(id: list_order_item.map(&:product_variant_id))
      result = variants.all? { |variant| variant.stock_movements.sum(&:quantity) == variant.current_stock }
      expect(result).to eq(true)
    end

    it 'success movement stock by order and variant exists delete old movement create new movement' do
      item = list_order_item.last
      product_variant = item.product_variant
      quantity = product_variant.stock_movements.sum(&:quantity)
      stock_1 = FactoryBot.create(:stock_movement,
                                  :inventory_out,
                                  :with_order,
                                  order: current_order,
                                  product_variant: product_variant,
                                  quantity: (quantity * -1))

      get :show, params: { order_token: current_order.token }
      stock = StockMovement.where(product_variant_id: product_variant.id, order_id: current_order.id)
      expect(stock.size).to eq(1)
      expect(stock.first.id != stock_1.id).to eq(true)
      expect(StockMovement.find_by(id: stock_1.id).nil?).to eq(true)
      expect(response.status).to eq(200)
    end
  end
end
