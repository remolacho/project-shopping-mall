class AddColumnRatingToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :rating, :float, default: 0
  end
end
