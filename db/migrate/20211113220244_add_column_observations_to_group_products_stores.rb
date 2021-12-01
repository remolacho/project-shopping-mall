class AddColumnObservationsToGroupProductsStores < ActiveRecord::Migration[6.0]
  def change
    add_column :group_products_stores, :observations, :string
  end
end
