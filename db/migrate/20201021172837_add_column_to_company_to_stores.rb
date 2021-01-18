class AddColumnToCompanyToStores < ActiveRecord::Migration[6.0]
  def change
    add_column :stores, :company_id, :integer, index: true
  end
end
