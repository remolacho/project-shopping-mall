class Orders::AssignUserData

  attr_accessor :order, :data

  def initialize(order:, data:)
    @order = order
    @data = data
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?

    required_fields
    order.user_data = data.to_h
    order.save!

    { user: order.user_data }
  end

  private

  def required_fields
    data.to_h.each do |key, value|
      raise ArgumentError, "#{key} es un campo obligatorio" unless value.present?
    end
  end

end
