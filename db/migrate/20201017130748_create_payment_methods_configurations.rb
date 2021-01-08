class CreatePaymentMethodsConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_methods_configurations do |t|
      t.integer :payment_method_id, index: true
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
