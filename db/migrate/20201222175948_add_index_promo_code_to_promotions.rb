class AddIndexPromoCodeToPromotions < ActiveRecord::Migration[6.0]
  def change
    add_index :promotions, :promo_code, unique: true
  end
end
