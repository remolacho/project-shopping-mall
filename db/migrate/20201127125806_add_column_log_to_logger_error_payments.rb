class AddColumnLogToLoggerErrorPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :loggers_error_payments, :log, :json, default: {}
  end
end
