class CreateChannelsRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :channels_rooms do |t|
      t.references :user, index: true, null: false
      t.references :store, index: true, null: false
      t.references :store_order, index: true, null: false
      t.string :token, null: false
      t.boolean :archived, default: false
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :channels_rooms, :token, unique: true
  end
end
