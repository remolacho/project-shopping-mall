class AddColumnSlugToOptionValues < ActiveRecord::Migration[6.0]
  def change
    add_column :option_values, :slug, :string
  end
end
