class AddColumnCommentToAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses, :comment, :string
  end
end
