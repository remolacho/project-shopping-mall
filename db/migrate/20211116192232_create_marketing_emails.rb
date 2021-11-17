class CreateMarketingEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :marketing_emails do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.timestamps
    end

    add_index :marketing_emails, :email, unique: true
  end
end
