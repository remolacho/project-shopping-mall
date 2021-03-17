class AddColumnStartOnToDeprecateOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :deprecate_order_items, :start_on, :date
  end
end
