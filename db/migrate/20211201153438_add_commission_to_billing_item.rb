class AddCommissionToBillingItem < ActiveRecord::Migration[6.0]
  def change
    add_column :bill_store_order_items, :zofri_commission_percentage, :float, null: false, default: 0.0
    add_column :bill_store_order_items, :mp_commission_percentage, :float, null: false, default: 0.0
  end
end
