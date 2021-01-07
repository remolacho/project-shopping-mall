class CreateSlides < ActiveRecord::Migration[6.0]
  def change
    create_table :slides do |t|
      t.string :name
      t.string :url_destination
      t.boolean :active, index: true
      t.timestamps
    end
  end
end
