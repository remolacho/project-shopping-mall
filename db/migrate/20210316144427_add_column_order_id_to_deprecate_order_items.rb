class AddColumnOrderIdToDeprecateOrderItems < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:deprecate_order_items, :order_id)
      add_column :deprecate_order_items, :order_id, :integer, index: true
    end
  end
end
