class AddTypeToShipmentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :shipment_methods, :shipment_type, :string
  end
end
