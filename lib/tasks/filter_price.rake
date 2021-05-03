# frozen_string_literal: true
# rake filter_price:run
namespace :filter_price do
  desc 'TODO'
  task run: :environment do
    ProductVariant.where(filter_price: nil).each do |pv|
      fp = !pv.discount_value.present? || pv.discount_value.zero? ? pv.price : pv.discount_value
      pv.filter_price = fp
      pv.save
    end
  end
end
