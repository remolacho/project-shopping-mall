class AddColumnCanPublishedToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :can_published, :boolean, default: false
  end
end
