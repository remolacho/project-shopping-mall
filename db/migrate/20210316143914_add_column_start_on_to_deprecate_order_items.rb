class AddColumnStartOnToDeprecateOrderItems < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:deprecate_order_items, :start_on)
      add_column :deprecate_order_items, :start_on, :date
    end
  end
end
