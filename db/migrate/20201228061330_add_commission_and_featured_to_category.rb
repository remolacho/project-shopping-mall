class AddCommissionAndFeaturedToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :commission, :float, default: 0.0
    add_column :categories, :featured, :boolean, default: false
  end
end
