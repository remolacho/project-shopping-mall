class RemoveColumnsIntegerToStoreOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :store_orders, :adjustment_total
    remove_column :store_orders, :clean_total
    remove_column :store_orders, :global_tax_total
    remove_column :store_orders, :payment_total
    remove_column :store_orders, :shipment_total
    remove_column :store_orders, :total
  end
end
