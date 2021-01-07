class ChangeColumnValueToOrderAdjustments < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_adjustments, :value
    add_column :order_adjustments, :value, :float, default: 0.0
  end
end
