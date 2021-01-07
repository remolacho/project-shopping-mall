class AddAdjustableToOrderAdjustment < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_adjustments, :adjustable, polymorphic: true, index: true
  end
end
