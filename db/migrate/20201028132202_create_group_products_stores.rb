class CreateGroupProductsStores < ActiveRecord::Migration[6.0]
  def change
    create_table :group_products_stores do |t|
      t.references :store, index: true
      t.string :file_name
      t.timestamps
    end
  end
end
