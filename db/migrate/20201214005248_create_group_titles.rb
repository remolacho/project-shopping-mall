class CreateGroupTitles < ActiveRecord::Migration[6.0]
  def change
    create_table :group_titles do |t|
      t.string :slug
      t.hstore :name_translations
      t.timestamps
    end
  end
end