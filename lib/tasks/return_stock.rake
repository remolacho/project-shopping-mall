# frozen_string_literal: true
# rake return_stock:run
namespace :return_stock do
  desc 'TODO'
  task run: :environment do
    movements = StockMovement.joins(:order)
                             .where('orders.state <> ?
                                     AND orders.payment_state = ?
                                     AND stock_movements.movement_type = ?',
                                     Order::IS_COMPLETED,
                                     Payment::UNSTARTED,
                                     StockMovement::INVENTORY_OUT)
                             .where('orders.updated_at <= ?', (Time.current - expired))

    movements.each(&:destroy!)
  end

  def expired
    eval(ENV['TIMEOUT_FREE_STOCK'])
  rescue StandardError
    3.hours
  end
end
