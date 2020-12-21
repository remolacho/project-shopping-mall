class AddColumnOrderIdToShippments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :order_id, :integer
    add_index :shipments, :order_id
  end
end
