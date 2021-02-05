# frozen_string_literal: true
class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :order, index: true, null: false
      t.references :product, index: true, null: false
      t.float :score, null: false, default: 1.0
      t.string :comment
      t.timestamps
    end

    add_index :reviews, %i[order_id product_id], unique: true
  end
end
