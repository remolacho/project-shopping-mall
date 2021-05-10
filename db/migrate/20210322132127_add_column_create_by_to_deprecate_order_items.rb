class AddColumnCreateByToDeprecateOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :deprecate_order_items, :created_by, :integer
  end
end
