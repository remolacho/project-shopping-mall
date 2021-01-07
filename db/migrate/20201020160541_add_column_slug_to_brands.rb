class AddColumnSlugToBrands < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :slug, :string
  end
end
