class CreateStoreInformationReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :store_information_reviews do |t|
      t.integer :store_id
      t.integer :approved_by_id
      t.integer :requested_by_id
      t.boolean :approved
      t.string :certifications
      t.string :facebook
      t.string :instagram
      t.string :mall_location
      t.string :name
      t.integer :sheets_row
      t.string :twitter
      t.string :website
      t.string :what_we_do
      t.integer :category_id
      t.integer :commune_id
      t.integer :company_id

      t.timestamps
    end
  end
end
