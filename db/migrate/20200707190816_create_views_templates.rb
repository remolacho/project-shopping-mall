class CreateViewsTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :views_templates do |t|
      t.string :name1
      t.integer :name2
      t.string :name3

      t.timestamps
    end
  end
end
