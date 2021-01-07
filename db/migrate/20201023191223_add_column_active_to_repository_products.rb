class AddColumnActiveToRepositoryProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :repository_products, :active, :boolean, default: false

    RepositoryProduct.all.update_all(active: true)
  end
end
