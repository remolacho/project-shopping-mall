class AddColumnNumberTicketToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :number_ticket, :string
  end
end
