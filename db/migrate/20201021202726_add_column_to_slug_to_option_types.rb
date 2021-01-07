class AddColumnToSlugToOptionTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :option_types, :slug, :string
  end
end
