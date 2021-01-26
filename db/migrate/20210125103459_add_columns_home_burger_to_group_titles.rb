class AddColumnsHomeBurgerToGroupTitles < ActiveRecord::Migration[6.0]
  def change
    add_column :group_titles, :home, :boolean, default: false
    add_column :group_titles, :burger, :boolean, default: false
  end
end
