class AddColumnCreateByToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :create_by, :integer, null: true
  end
end
