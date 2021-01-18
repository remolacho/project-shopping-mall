class CreateShipmentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_methods do |t|
      t.string :name
      t.string :description
      t.string :calculator_formula
      t.string :discount_forumla
      t.timestamps
    end
  end
end
