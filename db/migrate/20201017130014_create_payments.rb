class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :order_id, index: true
      t.integer :payment_method_id, index: true
      t.string :state
      t.integer :total
      t.json :payment_logs
      t.timestamps
    end
  end
end
