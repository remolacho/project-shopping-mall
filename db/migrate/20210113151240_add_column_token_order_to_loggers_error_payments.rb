class AddColumnTokenOrderToLoggersErrorPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :loggers_error_payments, :order_token, :string
  end
end
