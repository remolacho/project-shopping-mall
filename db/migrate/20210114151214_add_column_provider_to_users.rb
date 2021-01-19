class AddColumnProviderToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider, :string, default: 'zofri'.freeze
  end
end
