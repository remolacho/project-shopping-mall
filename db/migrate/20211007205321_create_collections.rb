class CreateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.string :slug
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
