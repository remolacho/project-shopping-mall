class AddColumnOrderIdToStockMovements < ActiveRecord::Migration[6.0]
  def change
    add_column :stock_movements, :order_id, :integer, index: true
  end
end
