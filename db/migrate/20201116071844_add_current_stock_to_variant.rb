class AddCurrentStockToVariant < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variants, :current_stock, :integer, default: 0
  end
end
