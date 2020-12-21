class AddColumnValueToShippments < ActiveRecord::Migration[6.0]
  def change
    add_column :shipments, :value, :float, default: 0.0
  end
end
