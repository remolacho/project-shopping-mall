class CreateLoggersErrorPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :loggers_error_payments do |t|
      t.string :payment_id
      t.string :message
      t.string :error
      t.string :number_ticket
      t.timestamps
    end
  end
end
