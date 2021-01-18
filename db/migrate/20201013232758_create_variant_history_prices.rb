class CreateVariantHistoryPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :variant_history_prices do |t|
      t.integer :product_variant_id, index: true
      t.float :value
      t.float :discount_value
      t.timestamps
    end
  end
end
