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

    let(:shipment_data_delivey){
      {shipment: {
          commune_id: commune.id,
          shipment_id: shipment_method.id,
          in_site: false,
          delivery_price: 2500,
          latitude: 0,
          longitude: 0,
          apartment_number: '',
          condominium: '',
          street: 'test street',
          street_number: '2568',
          comment: 'es una prueba de direccion'
      }}
    }

    let(:shipment_data_in_site){
      {shipment: {
          shipment_id: shipment_method_in_site.id,
          delivery_price: 0,
          latitude: 0,
          longitude: 0,
          firstname: 'test firstname',
          lastname: 'test lastname'
      }}
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

      order_adjustments = current_order.order_adjustments
      shipments = Shipment.all
      expect(order_adjustments.size).to eq(1)
      expect(shipments.size).to eq(1)

      expect(shipments.select{ |sh|
               sh.shipment_method_state.eql?(Shipment::INACTIVE) &&
          sh.state.eql?(Shipment::CANCELLED) }.size).to eq(0)

      expect(shipments.select{ |sh|
               sh.shipment_method_state.eql?(Shipment::ACTIVE) &&
          sh.state.eql?(Shipment::PENDING) }.size).to eq(1)

      expect(response.status).to eq(200)

      post :create, params: shipment_data_delivey.merge!(order_token: current_order.token)

      order_adjustments = current_order.order_adjustments
      shipments = Shipment.all
      expect(order_adjustments.size).to eq(2)
      expect(shipments.size).to eq(2)

      expect(shipments.select{ |sh|
        sh.shipment_method_state.eql?(Shipment::INACTIVE) &&
            sh.state.eql?(Shipment::CANCELLED) }.size).to eq(1)

      expect(shipments.select{ |sh|
        sh.shipment_method_state.eql?(Shipment::ACTIVE) &&
            sh.state.eql?(Shipment::PENDING) }.size).to eq(1)

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
