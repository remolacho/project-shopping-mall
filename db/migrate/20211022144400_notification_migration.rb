# frozen_string_literal: true

class NotificationMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :target, polymorphic: true, index: true
      t.string :segment_type, default: 'default'
      t.string :event_type, default: 'info'
      t.text :data
      t.boolean :read, default: false, null: false, index: true
      t.string :token
      t.timestamp :sent_at

      t.timestamps
    end
  end
end
