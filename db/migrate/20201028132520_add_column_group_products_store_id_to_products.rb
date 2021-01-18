class AddColumnGroupProductsStoreIdToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :group_products_store_id, :integer, index: true
  end
end
