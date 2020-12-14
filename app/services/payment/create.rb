# frozen_string_literal: true
class Payment::Create
  attr_accessor :data, :order, :payment

  def initialize(data:)
    @data = data
    @payment = Payment::Gateway::MercadoPago.new(attributes: data).perform
  end

  def perform
    return error_response('El pago ya fue aprobado') if is_approved_previously?
    return error_response if payment.errors_types.include?(payment.status)
    return success_response if payment.skip_status_types.include?(payment.status)
    return other_processes if payment.change_status_types.include?(payment.status)

    send(payment.status)
  rescue StandardError => e
    error_response(e.to_s)
  end

  private

  def approved
    ActiveRecord::Base.transaction do
      create_payment
      create_store_order(state: Order::IS_COMPLETED)
      update_order(state: Order::IS_COMPLETED, completed_at: Time.now)
    end

    success_response
  end

  def rejected
    ActiveRecord::Base.transaction do
      create_payment
      reverse_stock_movements
      update_order(state: Order::ON_PURCHASE)
    end

    success_response
  end

  def cancelled
    ActiveRecord::Base.transaction do
      create_payment
      reverse_stock_movements
      update_order(state: Order::ON_PURCHASE)
    end

    success_response
  end

  def refunded
    ActiveRecord::Base.transaction do
      create_payment
      update_order(state: StoreOrder::IS_COMPLETED, completed_at: Time.now)
    end

    success_response
  end

  def other_processes
    ActiveRecord::Base.transaction do
      create_payment
      update_order(state: Order::ON_PURCHASE)
    end

    success_response
  end

  def create_store_order(state:)
    store_items.each do |store_id, items|
      store_order = payment.order.store_orders.find_or_create_by!(store_id: store_id)
      store_order.delivery_state = payment.order.delivery_state
      store_order.payment_state = payment.status
      store_order.state = state
      store_order.save!

      assign_items_to_store(items, store_order)
      store_order.consolidate_payment_total
    end
  end

  def update_order(state:, completed_at: nil)
    payment.order.completed_at = completed_at
    payment.order.payment_state = payment.status
    payment.order.state = state
    payment.order.save!
  end

  def assign_items_to_store(items, store_order)
    items.each do |item|
      item.store_order_id = store_order.id
      item.save!
    end
  end

  def create_payment
    payment.order.payments.create!(
      payment_logs: payment.response,
      total: payment.order.payment_total,
      state: payment.status,
      payment_method_id: payment_method)
  end

  def reverse_stock_movements
    movements = payment.order.stock_movements.where(movement_type: StockMovement::INVENTORY_OUT)
    movements.each(&:destroy!)
  end

  def reverse_store_order
    store_orders = payment.order.store_orders.where(state: StoreOrder::IS_COMPLETED)
    store_orders&.delete_all!
  end

  def store_items
    @store_items ||= payment.order.order_items.group_by(&:store_id)
  end

  def payment_method
    @payment_method ||= PaymentMethod.first.id
  end

  def success_response
    { success: true, status: 200 }
  end

  def error_response(message=nil)
    { success: !logger_error(message), status: 404 }
  end

  def logger_error(message)
    LoggersErrorPayment.create(
      payment_id: payment.payment_id,
      message: message || payment.message,
      error: payment.status,
      number_ticket: payment.number_ticket,
      log: payment.response
    )
  end

  def is_approved_previously?
    payment.order.payment_state.eql?(Payment::APPROVED) &&
      payment.order.payments.any?{|pay| pay.state.eql?(Payment::APPROVED)} &&
      !payment.status.eql?(Payment::REFUNDED)
  end
end