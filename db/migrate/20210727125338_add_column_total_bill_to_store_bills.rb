class AddColumnTotalBillToStoreBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bill_stores, :total_bill, :float, null:false, default: 0
  end
end
