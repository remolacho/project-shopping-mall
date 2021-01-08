class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.integer :country_id, index: true
      t.string :name
      t.string :rut, index: true
      t.string :contact_email
      t.string :contact_phone
      t.string :fantasy_name
      t.string :legal_representative_rut, index: true
      t.string :legal_representative_name
      t.string :legal_representative_email
      t.string :legal_representative_phone

      t.timestamps
    end
  end
end
