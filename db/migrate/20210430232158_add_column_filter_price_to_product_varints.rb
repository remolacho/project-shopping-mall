# frozen_string_literal: true
class AddColumnFilterPriceToProductVarints < ActiveRecord::Migration[6.0]
  def change
    add_column :product_variants, :filter_price, :float, default: 0

    ProductVariant.all.each do |pv|
      fp = !pv.discount_value.present? || pv.discount_value.zero? ? pv.price : pv.discount_value
      pv.filter_price = fp
      pv.save
    end
  end
end
