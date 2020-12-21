class RemoveColumnOrderAdjustmentIdToShippments < ActiveRecord::Migration[6.0]
  def change
    remove_column :shipments, :order_adjustment_id
  end
end
