class CreateShipmentCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_costs do |t|
      t.references :commune, index: true, null: false
      t.integer :weight, index: true, null: false
      t.float :cost
      t.timestamps
    end
  end
end
