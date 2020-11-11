class CreateOrderProductReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :order_product_reviews do |t|
      t.references :order, index: true, null: false
      t.references :product, index: true, null: false
      t.references :user
      t.integer :rating, default: 0
      t.string :comment
      t.integer :status, default: 0
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
