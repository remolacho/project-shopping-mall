class RemoveRelationStoreToPromotions < ActiveRecord::Migration[6.0]
  def change
    remove_column :promotions, :store_id
  end
end
