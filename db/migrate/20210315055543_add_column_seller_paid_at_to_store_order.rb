class AddColumnSellerPaidAtToStoreOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :seller_paid_at, :datetime
    add_index :store_orders, :seller_paid_at
  end
end
