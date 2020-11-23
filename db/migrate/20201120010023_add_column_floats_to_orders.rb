class AddColumnFloatsToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :adjustment_total, :float, default: 0.0
    add_column :orders, :payment_total, :float, default: 0.0
    add_column :orders, :shipment_total, :float, default: 0.0
    add_column :orders, :tax_total, :float, default: 0.0
  end
end
