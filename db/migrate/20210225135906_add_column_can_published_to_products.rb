class AddColumnCanPublishedToProducts < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:products, :can_published)
      add_column :products, :can_published, :boolean, default: false
    end
  end
end
