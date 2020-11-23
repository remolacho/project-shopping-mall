# frozen_string_literal: true
class ShoppingCar::DeleteItem

  attr_accessor :user, :order, :order_item

  def initialize(user:, order:, order_item:)
    @user = user
    @order = order
    @order_item = order_item
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?

    ActiveRecord::Base.transaction do
      find_and_delete
      order.consolidate_payment_total
    end

    {success: true, order: ::Orders::ShoppingCarSerializer.new(order)}
  end

  private

  def find_and_delete
    item = order.order_items.find_by!(id: order_item)
    item.destroy!
  end
end
