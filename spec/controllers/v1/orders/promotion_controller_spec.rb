require 'rails_helper'

RSpec.describe V1::Orders::PromotionController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  let(:promo_code) { FactoryBot.create(:promotion, :amount_plain) }
  let(:promo_code_percentage) { FactoryBot.create(:promotion, :percentage) }
  let(:promo_code_not_started) { FactoryBot.create(:promotion, :amount_plain, :not_started) }
  let(:promo_code_expired) { FactoryBot.create(:promotion, :amount_plain, :expired) }
  let!(:auth_header) { request.headers['secret-api'] = ENV['SECRET_API'] }

  describe 'GET #apply' do
    it 'promotion is not started' do
      current_order.save
      list_order_item

      get :apply, params: {order_token: current_order.token, promo_code: promo_code_not_started.promo_code}
      expect(response.status).to eq(404)
    end

    it 'promotion is expired' do
      current_order.save
      list_order_item

      get :apply, params: {order_token: current_order.token, promo_code: promo_code_expired.promo_code}
      expect(response.status).to eq(404)
    end

    it 'the promotion is no longer valid' do
      current_order.state = Order::IS_COMPLETED
      current_order.save
      list_order_item
      promotion_adjustment

      get :apply, params: {order_token: current_order.token, promo_code: promo_code.promo_code}
      expect(response.status).to eq(404)
    end

    it 'only promotion by order' do
      current_order.save
      list_order_item
      promotion_adjustment

      get :apply, params: {order_token: current_order.token, promo_code: promo_code_percentage.promo_code}
      expect(response.status).to eq(404)
    end

    it 'success apply promotion amount plain' do
      current_order.save
      list_order_item

      get :apply, params: { order_token: current_order.token, promo_code: promo_code.promo_code }
      body = JSON.parse(response.body)

      total_pay = current_order.total_sum_order_items

      expect(body.dig('order', 'promotion_total') < 0).to eq(true)
      expect(body.dig('order', 'promotion_total')).to eq(promo_code.promotion_value * -1)
      expect(body.dig('order', 'payment_total')).to eq(total_pay + (promo_code.promotion_value * -1))
      expect(response.status).to eq(200)
    end

    it 'success apply promotion percentage' do
      current_order.save
      list_order_item

      get :apply, params: { order_token: current_order.token, promo_code: promo_code_percentage.promo_code }
      body = JSON.parse(response.body)

      total_pay = current_order.total_sum_order_items
      total_percentage = ((total_pay * promo_code_percentage.promotion_value) / 100) * -1

      expect(body.dig('order', 'promotion_total') < 0).to eq(true)
      expect(body.dig('order', 'promotion_total')).to eq(total_percentage)
      expect(body.dig('order', 'payment_total')).to eq(total_pay + total_percentage)
      expect(response.status).to eq(200)
    end
  end

end
