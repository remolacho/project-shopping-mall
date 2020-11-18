class AddColumnUserDataToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :user_data, :json, default: {}
  end
end
