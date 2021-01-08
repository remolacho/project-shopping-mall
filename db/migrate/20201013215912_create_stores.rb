class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.integer :commune_id, index: true
      t.string :certifications
      t.string :facebook
      t.string :instagram
      t.string :name, index: true
      t.integer :sheets_row
      t.string :twitter
      t.string :website
      t.string :what_we_do
      t.boolean :active
      t.string :mall_location, index: true

      t.timestamps
    end
  end
end
