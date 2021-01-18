class CreateVariantOptionsValues < ActiveRecord::Migration[6.0]
  def change
    create_table :variant_options_values do |t|
      t.integer :option_value_id, index: true
      t.integer :product_variant_id, index: true

      t.timestamps
    end
  end
end
