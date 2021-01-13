class RemoveNumberTicketToLoggersErrorPayments < ActiveRecord::Migration[6.0]
  def change
    remove_column :loggers_error_payments, :number_ticket
  end
end
