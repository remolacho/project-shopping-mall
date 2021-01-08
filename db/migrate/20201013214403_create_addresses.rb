class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :store_id, index: true
      t.integer :user_id, index: true
      t.integer :commune_id, index: true
      t.string :firstname
      t.string :lastname
      t.string :street
      t.string :street_number
      t.string :condominium
      t.string :apartment_number
      t.string :phone

      t.timestamps
    end
  end
end
