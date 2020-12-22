class Orders::ApplyPromotion
  attr_accessor :order, :promotion, :adjust

  def initialize(order:, promotion:)
    @order = order
    @promotion = promotion
  end

  def perform
    valid_promotion

    ActiveRecord::Base.transaction do
      create_adjust
      update_order
    end

    ::Orders::ShoppingCartSerializer.new(order, has_address: true)
  end

  private

  def valid_promotion
    raise ActiveRecord::RecordNotFound, 'promotion is not started' unless promotion.starts_at < Time.now
    raise ActiveRecord::RecordNotFound, 'promotion is expired' unless promotion.expires_at > Time.now
    raise ActiveRecord::RecordNotFound, 'the promotion is no longer valid' unless promotion.usage_limit > promotion.total_usage
    raise ActiveRecord::RecordNotFound, 'only promotion by order' if order.has_promotion?
  end

  def create_adjust
    self.adjust = promotion.order_adjustments.find_or_create_by(order_id: order.id)

    adjust.value = case promotion.promotion_type
                   when Promotion::AMOUNT_PLANE
                     promotion.promotion_value * -1
                   when Promotion::PERCENTAGE
                     ((order.total_sum_order_items * promotion.promotion_value) / 100) * -1
                   end

    adjust.description = 'apply_promotion'
    adjust.save!
  end

  def update_order
    order.consolidate_payment_total
  end
end
