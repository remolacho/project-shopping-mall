class CreateBrandCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :brand_categories do |t|
      t.references :category, index: true
      t.references :brand, index: true
      t.timestamps
    end
  end
end
