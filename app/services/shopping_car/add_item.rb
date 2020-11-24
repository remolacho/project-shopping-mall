# frozen_string_literal: true
class ShoppingCar::AddItem

  attr_accessor :user, :order, :product_variant, :store

  def initialize(user:, order:, product_variant:, store:)
    @user = user
    @order = order
    @product_variant = product_variant
    @store = store
  end

  def perform
    ActiveRecord::Base.transaction do
      find_or_create_order
      add_or_update_item
      order.consolidate_payment_total
    end

    {success: true, order: ::Orders::ShoppingCarSerializer.new(order)}
  end

  private

  def find_or_create_order
    self.order ||= Order.create!(user_id: user.try(:id),
                                 adjustment_total: 0,
                                 delivery_state: Order::UNSTARTED,
                                 payment_state: Order::UNSTARTED,
                                 payment_total: 0,
                                 tax_total: 0)
  end

  def add_or_update_item
    order_item = order.order_items.find_or_create_by(product_variant_id: product_variant.id,
                                                     store_id: store.id)

    order_item.item_qty = (order_item.item_qty.to_i + 1)
    order_item.unit_value = product_variant.price
    order_item.save!
  end
end