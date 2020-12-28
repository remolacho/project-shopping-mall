class RemoveColumnAdjustmentTotalToStoreOrder < ActiveRecord::Migration[6.0]
  def change
    remove_column :store_orders, :adjustment_total
  end
end
