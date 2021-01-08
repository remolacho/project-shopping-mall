class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.integer :store_id, index: true
      t.integer :brand_id, index: true
      t.integer :category_id, index: true
      t.json :name, default: {}
      t.json :short_description, default: {}
      t.json :description_translate, default: {}
      t.boolean :hide_from_results, default: false
      t.timestamps
    end
  end
end
