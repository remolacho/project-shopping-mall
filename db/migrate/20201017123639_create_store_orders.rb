class CreateStoreOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :store_orders do |t|
      t.integer :store_id, index: true
      t.integer :order_id, index: true
      t.string :mail
      t.string :order_number
      t.integer :payment_total
      t.string :phone
      t.string :special_comments
      t.string :state
      t.string :user_name
      t.string :payment_state
      t.string :delivery_state
      t.integer :global_tax_total
      t.integer :clean_total
      t.integer :adjustment_total
      t.integer :shipment_total
      t.integer :total
      t.timestamps
    end
  end
end
