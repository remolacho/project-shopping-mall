class Orders::AssignUserData

  attr_accessor :order, :data

  def initialize(order:, data:)
    @order = order
    @data = data
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'la orden no esta en estado ON_PURCHASE' unless order.present?
    raise ArgumentError, 'no hay usuario asociado' if data.class.eql?(String)
    raise ArgumentError, 'no hay usuario asociado' unless data.present?

    required_fields
    order.user_data = data
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
