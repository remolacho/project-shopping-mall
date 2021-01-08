class AddColumnIsMasterToProductVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variants, :is_master, :boolean, default: false
  end
end
