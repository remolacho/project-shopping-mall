# frozen_string_literal: true
class ShoppingCart::Items

  attr_accessor :user, :order

  def initialize(user:, order:)
    @user = user
    @order = order
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?

    {success: true, order: ::Orders::ShoppingCartSerializer.new(order)}
  end
end


