class SellersPaymentWorker
  include Sidekiq::Worker

  def perform()
    store_orders = StoreOrder.where(seller_paid_at: nil, payment_state: 'approved', state: 'completed')
    
    store_orders.each do |so|
      if so.completed_at <= 5.day.ago
        payment = 0
        total = 0
        payment_type = so.order.payments.last.payment_logs['payment_type_id']

        if payment_type == 'bank_transfer'
          mp_commission = 1.8921
        elsif payment_type == 'credit_card'
          mp_commission = 3.6771
        end

        p '========================='

        total = so.payment_total

        so.order_items.each do |oi|
          oi_total = oi.unit_value * oi.item_qty
          commission = oi.product_variant.product.category.path.where.not(commission: 0.0).reverse_order.first.try(:commission)
          oi_payment = oi_total * (100 - (mp_commission + commission)) / 100
          payment += oi_payment.to_i
          p "order item: #{oi.id}, total orden: #{total}, cat_id #{oi.product_variant.product.category.id}, tarifa: #{commission}, total: #{oi_payment}"
        end
        
        p "total a pagar: #{payment}"

        email = so.store.store_payment_methods_configurations_values.find_by(payment_methods_configuration_id: PaymentMethodsConfiguration.find_by(name: "account_mail").id).try(:value)
        if email.present
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
          so.update!(seller_paid_at: DateTime.now) if response['status'] === 'approved'
          p 'Pagado'
        else
          p 'No Pagado'
        end
        p '========================='
      end
    end
  end
end
