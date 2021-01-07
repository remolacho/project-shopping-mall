class AddMissingFieldsToUserV1 < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :jti, :string
  	add_column :users, :complementary_info, :json
  end
end


