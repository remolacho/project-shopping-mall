class SellersPaymentWorker
  include Sidekiq::Worker

  def payment_logger
    @@payment_logger ||= Logger.new("#{Rails.root}/log/payment.log")
  end

  def perform()
    store_orders = StoreOrder.where(seller_paid_at: nil, payment_state: 'approved', state: 'completed')
    
    store_orders.each do |so|
      begin
        if so.order.completed_at <= 5.day.ago && so.order.state == 'completed' && so.order.payment_state == 'approved'
          p "ORDEN #{so.order.id},  SO #{so.id}"
          payment = 0
          total = 0
          payment_type = so.order.payments.last.payment_logs['payment_type_id']

          if payment_type == 'bank_transfer' || payment_type == 'debit_card'
            mp_commission = 1.8921
          elsif payment_type == 'credit_card'
            mp_commission = 3.6771
          else
            mp_commission = 1.8921
          end

          p '========================='

          total = so.payment_total

          so.order_items.each do |oi|
            oi_total = oi.unit_value * oi.item_qty
            commission = oi.variant_including_deleted.product_including_deleted.category.path.where.not(commission: 0.0).reverse_order.first.try(:commission)
            oi_payment = oi_total * (100 - (mp_commission + commission)) / 100
            payment += oi_payment.to_i
            p "order item: #{oi.id}, total orden: #{total}, cat_id #{oi.variant_including_deleted.product_including_deleted.category.id}, tarifa: #{commission}, total: #{oi_payment}"
          end
          p "total a pagar: #{payment}"

          email = so.store.store_payment_methods_configurations_values.find_by(payment_methods_configuration_id: PaymentMethodsConfiguration.find_by(name: "account_mail").id).try(:value)
          if email.present?
            require 'uri'
            require 'net/http'

            url = URI("https://api.mercadopago.com/v1/payments?access_token=#{ENV['SELLER_PAYMENTS_TOKEN']}")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(url)
            request["content-type"] = 'application/json'
            request["cache-control"] = 'no-cache'
            request.body = "{\n
                              \"transaction_amount\": #{payment},\n
                              \"payment_method_id\": \"account_money\",\n
                              \"operation_type\": \"money_transfer\",\n
                              \"marketplace\": \"NONE\",\n
                              \"collector\": {\n
                                \"email\": \"#{email}\"\n
                              },\n
                              \"external_reference\": \"Pago_#{so.order_number}\",\n
                              \"description\": \"Pago a tienda, Orden #{so.order_number}\"\n
                            }"

            response = JSON.parse(http.request(request).read_body)
            if response['status'] === 'approved'
              p 'Pagado'
              so.update!(seller_paid_at: DateTime.now)
              payment_logger.info("==================")
              payment_logger.info("[SO: #{so.order_number}, id: #{so.id}] Store order pagada")
              payment_logger.info("[SO: #{so.order_number}, id: #{so.id}] Cuenta: #{email} ,  Monto: #{payment}")
              payment_logger.info("==================")
            else
              p 'Rechazado por MercadoPago'
              payment_logger.warn("==================")
              payment_logger.warn("[SO: #{so.order_number}, id: #{so.id}] Rechazado por MercadoPago")
              payment_logger.warn("--------")
              payment_logger.warn(response)
              payment_logger.warn("==================")
            end

          else
            p 'No Pagado'
            payment_logger.warn("==================")
            payment_logger.warn("[SO: #{so.order_number}, id: #{so.id}] No se pudo pagar")
            payment_logger.warn("[SO: #{so.order_number}, id: #{so.id}] La store no tiene un mail de MercadoPago asociado")
            payment_logger.warn("==================")
          end
          p '========================='
        end
      rescue => error
        payment_logger.error("==================")
        payment_logger.error("[SO: #{so.order_number}, id: #{so.id}] Un error impidio el pago")
        payment_logger.error("--------")
        payment_logger.error(error)
        payment_logger.error("==================")
        next
      end
    end
  end
end
