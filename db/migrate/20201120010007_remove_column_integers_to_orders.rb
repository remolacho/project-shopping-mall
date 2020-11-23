class RemoveColumnIntegersToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :adjustment_total
    remove_column :orders, :shipment_total
    remove_column :orders, :payment_total
    remove_column :orders, :tax_total
  end
end
