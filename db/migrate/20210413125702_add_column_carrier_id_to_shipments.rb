class AddColumnCarrierIdToShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :carrier_id, :integer, index: true
  end
end
