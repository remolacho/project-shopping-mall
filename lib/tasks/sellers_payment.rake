namespace :sellers_payment do
  desc "Realiza el pago de ordenes a las stores"
  task run: :environment do

    store_orders = StoreOrder.where(seller_paid_at: nil, payment_state: 'approved')
    
    store_orders.each do |so|
      payment = 0
      total = 0

      p '========================='

      total = so.payment_total

      so.order_items.each do |oi|
        oi_total = (oi.unit_value * oi.item_qty) * (100 - 1.9) / 100
        commission = oi.product_variant.product.category.path.where.not(commission: 0.0).reverse_order.first.commission
        oi_payment = oi_total * (100 - commission) / 100
        payment += oi_payment
        p "order item: #{oi.id}, total orden: #{total}, cat_id #{oi.product_variant.product.category.id}, tarifa: #{commission}, total: #{oi_payment}"
      end
      
      p "total a pagar: #{payment}"

      email = so.store.store_payment_methods_configurations_values.find_by(payment_methods_configuration_id: PaymentMethodsConfiguration.find_by(name: "account_mail").id).value
      require 'uri'
      require 'net/http'

      url = URI("https://api.mercadopago.com/v1/payments?access_token=APP_USR-7744138392274043-010813-0ea777e000b24c025138434f1fd9b907-667352463")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/json'
      request["cache-control"] = 'no-cache'
      request["postman-token"] = 'b3cf51bf-8570-0a26-2239-92f430d7d938'
      request.body = "{\n  
                        \"transaction_amount\": #{payment},\n  
                        \"payment_method_id\": \"account_money\",\n  
                        \"collector\": {\n    
                          \"email\": \"#{email}\"\n  
                        },\n  
                        \"external_reference\": \"Pago_#{so.id}\",\n  
                        \"description\": \"Pago a tienda, Orden #{so.id}\"\n
                      }"

      response = http.request(request)
      so.update!(seller_paid_at: DateTime.now) if response.kind_of? Net::HTTPSuccess

      p '========================='
    end
    
    
  end
end