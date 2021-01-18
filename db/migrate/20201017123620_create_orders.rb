class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, index: true
      t.integer :address_id
      t.datetime :completed_at
      t.string :state
      t.integer :payment_total
      t.integer :tax_total
      t.integer :shipment_total
      t.integer :adjustment_total
      t.string :delivery_state
      t.string :payment_state
      t.timestamps
    end
  end
end
