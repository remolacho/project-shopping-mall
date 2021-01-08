class CreateProductVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :product_variants do |t|
      t.integer :product_id, index: true
      t.integer :brand_id, index: true
      t.json :name, default: {}
      t.json :short_description, default: {}
      t.string :sku, index: true
      t.string :internal_sku, index: true
      t.boolean :active
      t.float :price
      t.float :discount_value
      t.float :weight
      t.float :height
      t.float :width
      t.float :length

      t.timestamps
    end
  end
end
