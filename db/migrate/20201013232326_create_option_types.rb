class CreateOptionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :option_types do |t|
      t.json :name, default: {}
      t.timestamps
    end
  end
end
