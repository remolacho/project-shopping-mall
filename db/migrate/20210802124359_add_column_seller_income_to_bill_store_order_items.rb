class AddColumnSellerIncomeToBillStoreOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :bill_store_order_items, :seller_income, :float, default: 0
  end
end
