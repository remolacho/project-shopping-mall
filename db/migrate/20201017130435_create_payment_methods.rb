class CreatePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.string :description
      t.boolean :active
      t.integer :position
      t.timestamps
    end
  end
end
