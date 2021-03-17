class AddColumnOrderIdToDeprecateOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :deprecate_order_items, :order_id, :integer, index: true
  end
end
