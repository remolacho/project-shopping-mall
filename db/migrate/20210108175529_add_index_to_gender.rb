class AddIndexToGender < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :gender
  end
end
