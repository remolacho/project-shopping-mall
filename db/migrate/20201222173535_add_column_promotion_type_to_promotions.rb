class AddColumnPromotionTypeToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :promotion_type, :string
    add_column :promotions, :promotion_value, :float

  end
end
