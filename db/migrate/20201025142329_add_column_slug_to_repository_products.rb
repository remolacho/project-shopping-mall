class AddColumnSlugToRepositoryProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :repository_products, :slug, :string
  end
end
