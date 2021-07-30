class CreateBillStores < ActiveRecord::Migration[6.0]
  def change
    create_table :bill_stores do |t|
      t.references :store, null: false, index: true
      t.references :store_module, null: false, index: true
      t.string :ticket_number, null: false
      t.date :ticket_date, null: false
      t.timestamps
    end
  end
end
