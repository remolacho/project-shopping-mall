class CreateAds < ActiveRecord::Migration[6.0]
  def change
    create_table :ads do |t|
      t.string :name
      t.string :url_destination
      t.integer :ad_type, index: true
      t.boolean :active, index: true
      t.timestamps
    end
  end
end
