class AddColumnUidToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string, null: true
    add_index :users, :uid, unique: true
  end
end
