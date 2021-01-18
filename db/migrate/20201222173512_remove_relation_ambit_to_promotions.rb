class RemoveRelationAmbitToPromotions < ActiveRecord::Migration[6.0]
  def change
    remove_column :promotions, :ambit
  end
end
