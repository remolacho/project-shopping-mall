class DataIsMasterToProductVariants < ActiveRecord::Migration[6.0]
  def change
    Product.includes(:product_variants).all.each do |product|
      next unless product.product_variants.present?
      min_price = product.product_variants.map(&:price).min
      variant = product.product_variants.detect{|pv| pv.price == min_price }
      if variant.present?
        variant.is_master = true
        variant.save
        puts 'actualiza a master la variante'
        puts "min price: #{min_price}"
        puts "product name:#{product.name}"
        puts '*******************************************************'
      end
    end
  end
end
