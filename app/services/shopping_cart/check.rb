# frozen_string_literal: true
class ShoppingCart::Check

  attr_accessor :user, :order

  def initialize(user:, order:)
    @user = user
    @order = order
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?
    check_order.to_h
  end

  private

  def check_order
    error_item = []
    order_items = order.order_items.includes(product_variant: :stock_movements)

    order_items.each do |item|
      quantity = item.product_variant.stock_movements.sum(&:quantity)
      if item.item_qty > quantity
        error_item << object(item, :quantity, 'la catidad exede la existencia')
        next
      end

      unless item.unit_value == item.product_variant.price
        error_item << object(item, :price, "error en precio: #{item.unit_value}, precio actual: #{item.product_variant.price}")
        next
      end
    end

    return struct.new(false, error_item, 203) if error_item.present?

    stock_movements(order_items)
  end

  def stock_movements(order_items)
    ActiveRecord::Base.transaction do
      order_items.each do |item|
        order.stock_movements.create!(
          movement_type: StockMovement::INVENTORY_OUT,
          quantity: (item.item_qty * -1),
          product_variant_id: item.product_variant_id
        )
      end
    end

    struct.new(true, [], 200)
  end

  def struct
    @struct ||= Struct.new(:success, :items_errors, :state)
  end

  def object(item, error_type, message)
    {
      id: item.id,
      product_variant_id: item.product_variant_id,
      unit_value: item.unit_value,
      item_qty: item.item_qty,
      error_type: error_type,
      message: message
    }
  end
end

