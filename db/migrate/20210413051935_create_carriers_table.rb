class CreateCarriersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :carriers do |t|
      t.string :name, index: true
      t.string :reference, index: true
      t.string :slug, index: true
      t.timestamps
    end
  end
end
