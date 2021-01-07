class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.integer :store_id, index: true
      t.string :ambit
      t.json :name, default: {}
      t.datetime :starts_at
      t.datetime :expires_at
      t.string :promo_code
      t.integer :usage_limit
      t.string :rules
      t.timestamps
    end
  end
end
