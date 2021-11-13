class AddColumnStatusToGroupProductsStores < ActiveRecord::Migration[6.0]
  def change
    add_column :group_products_stores, :status, :integer, default: 2
  end
end
