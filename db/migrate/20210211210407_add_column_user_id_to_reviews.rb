class AddColumnUserIdToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :user_id, :integer, index: :true
  end
end
