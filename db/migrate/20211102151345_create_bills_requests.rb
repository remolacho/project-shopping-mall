class CreateBillsRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :bills_requests do |t|
      t.string :ticket, null: false
      t.string :description
      t.integer :status, default: 0
      t.timestamps
    end

    add_index :bills_requests, :ticket, unique: true
  end
end
