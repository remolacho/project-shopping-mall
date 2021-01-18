class CreateStorePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :store_payment_methods do |t|
      t.integer :store_id, index: true
      t.integer :payment_method_id, index: true
      t.timestamps
    end
  end
end
