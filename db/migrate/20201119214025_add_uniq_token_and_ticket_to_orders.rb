class AddUniqTokenAndTicketToOrders < ActiveRecord::Migration[6.0]
  def change
    add_index :orders, :token, unique: true
    add_index :orders, :number_ticket, unique: true
  end
end
