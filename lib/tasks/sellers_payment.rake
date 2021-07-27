namespace :sellers_payment do
  desc "inicia el pago de ordenes a las stores"
  task run: :environment do
    SellersPaymentWorker.new.perform 
  end
end