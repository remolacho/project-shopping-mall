class CreateRepositoryProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :repository_products do |t|
      t.references :category
      t.json :name
      t.string :brand
      t.string :code
      t.string :side_code
      t.timestamps
    end
  end
end
