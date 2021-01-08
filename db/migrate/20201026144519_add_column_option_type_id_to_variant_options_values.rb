class AddColumnOptionTypeIdToVariantOptionsValues < ActiveRecord::Migration[6.0]
  def change
    add_column :variant_options_values, :option_type_id, :integer, index: true
  end
end
