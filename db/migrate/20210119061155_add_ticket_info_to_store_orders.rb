class AddTicketInfoToStoreOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :ticket_number, :string
    add_column :store_orders, :ticket_date, :date
    add_column :store_orders, :module, :string
  end
end
