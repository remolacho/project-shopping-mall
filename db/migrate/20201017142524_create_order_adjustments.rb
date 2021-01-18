class CreateOrderAdjustments < ActiveRecord::Migration[6.0]
  def change
    create_table :order_adjustments do |t|
      t.string :description
      t.string :value
      t.timestamps
    end
  end
end
