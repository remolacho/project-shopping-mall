class CreateBillStoreOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :bill_store_order_items do |t|
      t.references :bill_store, null: false, index: true
      t.references :order_item, null: false, index: true
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
