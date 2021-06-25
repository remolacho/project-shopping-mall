shared_context 'shipment_stuff' do
  let(:carrier) { FactoryBot.create(:carrier) }

  # shipment_method viene de meta_data_stuff
  let(:shipment) { FactoryBot.create(:shipment, shipment_method: shipment_method) }

  # commune viene desde company_stuff
  let(:shipment_cost) {
    FactoryBot.create(:shipment_cost, carrier: carrier, commune: commune)
  }
end
