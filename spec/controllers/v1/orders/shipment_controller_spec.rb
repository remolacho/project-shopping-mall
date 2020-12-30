require 'rails_helper'

RSpec.describe V1::Orders::ShipmentController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "POST #create" do

    let!(:auth_header) {
      request.headers['secret-api'] = ENV['SECRET_API']
    }

    it 'success in site' do
      current_order.save
      list_order_item

      post :create, params: shipment_data_in_site.merge!(order_token: current_order.token)
      expect(response.status).to eq(200)
    end

    it 'success in delivery but before in site' do
      current_order.save
      list_order_item

      post :create, params: shipment_data_in_site.merge!(order_token: current_order.token)

      shipment_first = current_order.shipment
      expect(shipment_first.present?).to eq(true)

      expect(shipment_first.shipment_method_state.eql?(Shipment::INACTIVE) &&
              shipment_first.state.eql?(Shipment::CANCELLED)).to eq(false)

      expect(shipment_first.shipment_method_state.eql?(Shipment::ACTIVE) &&
                 shipment_first.state.eql?(Shipment::PENDING)).to eq(true)

      expect(shipment_first.shipment_method.shipment_type.eql?(ShipmentMethod::IN_SITE_TYPE)).to eq(true)

      post :create, params: shipment_data_delivey.merge!(order_token: current_order.token)

      shipment_last = current_order.shipment.reload
      expect(shipment_last.id == shipment_first.id).to eq(true)

      expect(shipment_last.shipment_method_state.eql?(Shipment::INACTIVE) &&
                 shipment_last.state.eql?(Shipment::CANCELLED)).to eq(false)

      expect(shipment_last.shipment_method_state.eql?(Shipment::ACTIVE) &&
                 shipment_last.state.eql?(Shipment::PENDING)).to eq(true)

      expect(shipment_last.shipment_method.shipment_type.eql?(ShipmentMethod::DELIVERY_TYPE)).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'error in site empty field' do
      current_order.save
      list_order_item
      shipment_data_in_site[:shipment].merge!(firstname: '')
      post :create, params: shipment_data_in_site.merge!(order_token: current_order.token)
      expect(response.status).to eq(422)
    end

    it 'error in site price > 0' do
      current_order.save
      list_order_item
      shipment_data_in_site[:shipment].merge!(delivery_price: '2500.8')
      post :create, params: shipment_data_in_site.merge!(order_token: current_order.token)
      expect(response.status).to eq(422)
    end

    it 'error delivery price empty' do
      current_order.save
      list_order_item
      shipment_data_delivey[:shipment].merge!(delivery_price: '')
      post :create, params: shipment_data_delivey.merge!(order_token: current_order.token)
      expect(response.status).to eq(422)
    end

    it 'error delivery street_number empty' do
      current_order.save
      list_order_item
      shipment_data_delivey[:shipment].merge!(street_number: '')
      post :create, params: shipment_data_delivey.merge!(order_token: current_order.token)
      expect(response.status).to eq(422)
    end

    it 'error delivery street empty' do
      current_order.save
      list_order_item
      shipment_data_delivey[:shipment].merge!(street: '')
      post :create, params: shipment_data_delivey.merge!(order_token: current_order.token)
      expect(response.status).to eq(422)
    end

  end

end
