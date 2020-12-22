class RemoveColumnAdjustmentTotalToOrder < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :adjustment_total
  end
end
