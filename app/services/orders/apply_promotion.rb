class Orders::ApplyPromotion
  attr_accessor :order, :promotion, :adjust

  def initialize(order:, promotion:)
    @order = order
    @promotion = promotion
  end

  def perform
    return response_error(100, 'La promoción no esta activa')  if not_started?
    return response_error(101, 'La promoción esta vencida')    if is_expired?
    return response_error(102, 'La promoción ya no es válida') if not_valid?
    return response_error(103, 'Solo 1 promoción por orden')   if order.has_promotion?
    return response_error(104, 'El costo no aplica para procesar el pago') if not_allowed_value?

    ActiveRecord::Base.transaction do
      create_adjust
      update_order
    end

    ::Orders::ShoppingCartSerializer.new(order, has_address: true)
  end

  private

  def not_started?
    promotion.starts_at > Time.now
  end

  def is_expired?
    promotion.expires_at < Time.now
  end

  def not_valid?
    promotion.total_usage >= promotion.usage_limit
  end

  def not_allowed_value?
    (total_pay - (value_promotion * -1)) <= 1000
  end

  def create_adjust
    self.adjust = promotion.order_adjustments.find_or_create_by(order_id: order.id)
    adjust.value = value_promotion
    adjust.description = 'apply_promotion'
    adjust.save!
  end

  def update_order
    order.consolidate_payment_total
  end

  def total_pay
    @total_pay ||= order.total_sum_order_items
  end

  def value_promotion
    @value_promotion ||= case promotion.promotion_type
                         when Promotion::AMOUNT_PLANE
                           promotion.promotion_value * -1
                         when Promotion::PERCENTAGE
                           ((total_pay * promotion.promotion_value) / 100) * -1
                         end
  end

  def response_error(code, message)
    { success: false, code: code, message: message }
  end
end
