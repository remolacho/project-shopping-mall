class AddColumnPaymentMethodToBillStores < ActiveRecord::Migration[6.0]
  def change
    add_column :bill_stores, :payment_method, :string
  end
end
