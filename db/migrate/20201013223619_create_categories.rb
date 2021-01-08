class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.json :name, default: {}
      t.string :slug
      t.integer :depth
      t.timestamps
    end
  end
end
