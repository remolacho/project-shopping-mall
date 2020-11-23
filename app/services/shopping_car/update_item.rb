# frozen_string_literal: true
class ShoppingCar::UpdateItem

  attr_accessor :user, :order, :order_item, :data

  def initialize(user:, order:, order_item:, data:)
    @user = user
    @order = order
    @order_item = order_item
    @data = data
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?
    raise ActiveRecord::RecordNotFound, 'the quantity is not number' unless data[:item_qty].to_s.numeric?

    ActiveRecord::Base.transaction do
      find_and_update
      order.consolidate_payment_total
    end

    {success: true, order: ::Orders::ShoppingCarSerializer.new(order)}
  end

  private

  def find_and_update
    item = order.order_items.find_by!(id: order_item)
    return item.destroy! if data[:item_qty].to_i.zero?

    item.item_qty = data[:item_qty]
    item.save!
  end
end

