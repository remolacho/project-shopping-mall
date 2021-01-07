class CreateStockMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_movements do |t|
      t.integer :product_variant_id, index: true
      t.integer :quantity, default: 0
      t.string :movement_type

      t.timestamps
    end
  end
end
