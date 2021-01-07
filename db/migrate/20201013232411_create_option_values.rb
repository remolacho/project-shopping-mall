class CreateOptionValues < ActiveRecord::Migration[6.0]
  def change
    create_table :option_values do |t|
      t.integer :option_type_id, index: true
      t.json :value, default: {}
      t.timestamps
    end
  end
end
