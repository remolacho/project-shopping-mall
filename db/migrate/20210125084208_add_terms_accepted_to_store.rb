class AddTermsAcceptedToStore < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :terms_accepted, :boolean, default: false
  end
end
