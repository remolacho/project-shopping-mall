# frozen_string_literal: true

class ShoppingCart::Check
  attr_accessor :user, :order

  def initialize(user:, order:)
    @user = user
    @order = order
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?

    assign_user if user.present?
    check_order.to_h
  end

  private

  def check_order
    error_item = []
    order_items = order.order_items.includes(product_variant: :stock_movements)

    order_items.each do |item|
      quantity = item.product_variant.stock_movements.sum(&:quantity)
      stock = order.stock_movements.find_by(product_variant_id: item.product_variant_id)

      if stock.nil? && item.item_qty > quantity
        error_item << object(item, :quantity, 'No hay stock suficiente')
        next
      end

      unless item.unit_value == item.product_variant.current_price
        error_item << object(item, :price, "error en precio: #{item.unit_value}, precio actual: #{item.product_variant.current_price}")
        next
      end
    end

    return struct.new(false, error_item, 203) if error_item.present?

    stock_movements(order_items)
  end

  def stock_movements(order_items)
    ActiveRecord::Base.transaction do
      old_movement = order.stock_movements.where(movement_type: StockMovement::INVENTORY_OUT)
      old_movement.each(&:destroy!)

      order_items.each do |item|
        order.stock_movements.create!(
          movement_type: StockMovement::INVENTORY_OUT,
          quantity: (item.item_qty * -1),
          product_variant_id: item.product_variant_id
        )
      end

      order.update!(payment_state: Payment::UNSTARTED)
    end

    struct.new(true, [], 200)
  end

  def assign_user
    order.update(user_id: user.id) unless user.nil?
  end

  def struct
    @struct ||= Struct.new(:success, :items_errors, :state)
  end

  def object(item, error_type, message)
    {
      id: item.id,
      name: item.product_variant.name,
      product_variant_id: item.product_variant_id,
      unit_value: item.unit_value,
      item_qty: item.item_qty,
      error_type: error_type,
      message: message
    }
  end
end
