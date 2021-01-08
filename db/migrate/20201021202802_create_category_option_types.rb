class CreateCategoryOptionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :category_option_types do |t|
      t.references :category, index: true
      t.references :option_type, index: true
      t.timestamps
    end
  end
end
