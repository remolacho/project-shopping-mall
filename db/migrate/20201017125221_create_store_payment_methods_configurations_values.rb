class CreateStorePaymentMethodsConfigurationsValues < ActiveRecord::Migration[6.0]
  def change
    create_table :store_payment_methods_configurations_values do |t|
      t.integer :payment_methods_configuration_id
      t.integer :store_payment_method_id
      t.string :value
      t.timestamps
    end
  end
end
