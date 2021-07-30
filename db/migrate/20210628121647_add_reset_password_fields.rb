class AddResetPasswordFields < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reset_password_token_expires_at, :datetime, default: nil
  end
end
