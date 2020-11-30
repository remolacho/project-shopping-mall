class AddColumnsFloatToStoreOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :adjustment_total, :float, default: 0.0
    add_column :store_orders, :clean_total, :float, default: 0.0
    add_column :store_orders, :global_tax_total, :float, default: 0.0
    add_column :store_orders, :payment_total, :float, default: 0.0
    add_column :store_orders, :shipment_total, :float, default: 0.0
    add_column :store_orders, :total, :float, default: 0.0
  end
end
