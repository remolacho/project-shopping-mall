class CreateCollectionProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_products do |t|
      t.references :product, index: true, null: false
      t.references :collection, index: true, null: false
      t.timestamps
    end
  end
end
