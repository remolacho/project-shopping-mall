class CreateStoreModules < ActiveRecord::Migration[6.0]
  def change
    create_table :store_modules do |t|
      t.references :store, null: false , index: true
      t.string :num_module, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
