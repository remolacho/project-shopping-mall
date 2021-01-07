class CreateGroupTitleCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :group_title_categories do |t|
      t.references :group_title, index: true, null: false
      t.references :category, index: true, null: false
      t.timestamps
    end
  end
end
