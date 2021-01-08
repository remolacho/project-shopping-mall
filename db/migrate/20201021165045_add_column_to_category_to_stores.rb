class AddColumnToCategoryToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :category_id, :integer, index: true
  end
end
