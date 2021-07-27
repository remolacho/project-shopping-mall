class CreateStoreDownloadFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :store_download_files do |t|
      t.references :store, index: true
      t.references       :user, index: true
      t.string :type_file
      t.timestamps
    end
  end
end
