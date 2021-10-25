class CreateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.string :slug
      t.datetime :start_date
      t.datetime :end_date
      t.string :status, default: 'inactive'
      t.timestamps
    end
  end
end
