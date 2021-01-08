class RemoveColumnBrandIdToProductVariants < ActiveRecord::Migration[6.0]
  def change
    remove_column :product_variants, :brand_id
  end
end
