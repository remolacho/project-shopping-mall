class AddColumnCarrierIdToShipmentCosts < ActiveRecord::Migration[6.0]
  def change
    add_column :shipment_costs, :carrier_id, :integer, index: true
  end
end
