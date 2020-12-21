class AddColumnOrderIdToOrderAdjustments < ActiveRecord::Migration[6.0]
  def change
    add_column :order_adjustments, :order_id, :integer
    add_index :order_adjustments, :order_id
  end
end
