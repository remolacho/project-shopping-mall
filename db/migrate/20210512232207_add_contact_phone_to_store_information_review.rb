class AddContactPhoneToStoreInformationReview < ActiveRecord::Migration[6.0]
  def change
    add_column :store_information_reviews, :contact_phone, :string, :null => true
    add_column :stores, :contact_phone, :string, :null => true
  end
end
