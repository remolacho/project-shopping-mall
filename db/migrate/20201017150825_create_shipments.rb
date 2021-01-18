class CreateShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :shipments do |t|
      t.references :order_adjustment, index: true
      t.references :shipment_method, index: true
      t.string :state
      t.string :tracking_code
      t.string :shipment_method_state
      t.timestamps
    end
  end
end
