class CreateCommunes < ActiveRecord::Migration[6.0]
  def change
    create_table :communes do |t|
      t.integer :region_id
      t.string :name

      t.timestamps
    end
  end
end
