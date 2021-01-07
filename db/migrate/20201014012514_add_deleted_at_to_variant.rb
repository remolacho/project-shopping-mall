class AddDeletedAtToVariant < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variants, :deleted_at, :datetime
    add_index :product_variants, :deleted_at
  end
end
