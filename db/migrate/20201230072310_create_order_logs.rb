class CreateOrderLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :order_logs do |t|
      t.references :store_order, index: true
      t.references :order, index: true
      t.string :log
      t.timestamps
    end
  end
end
