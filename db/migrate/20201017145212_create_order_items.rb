class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :product_variant, index: true
      t.references :store_order, index: true
      t.references :store, index: true
      t.integer :item_qty
      t.float :unit_value
      t.timestamps
    end
  end
end
