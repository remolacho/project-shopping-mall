shared_context 'stores_products_stuff' do
  let(:stores_list) {
    FactoryBot.create_list(:store, 5,
                           :is_active,
                           commune: Commune.first,
                           category: Category.first,
                           company: Company.first)
  }

  let(:products_list) {
    stores_list.each { |store|

      FactoryBot.create_list(:product, 2,
                             :with_image,
                             category: root_category,
                             store: store,
                             brand: brands_list.first,
                             rating: 3).map { |product|

        [1000, 2000, 3000].each_with_index do |price, index|
          product_variant = FactoryBot.create(:product_variant, :is_active, product: product, price: price, is_master: index.zero?)
          FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 100)
          FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 12)
          FactoryBot.create(:stock_movement, :inventory_out, product_variant: product_variant, quantity: -10)
        end

        product
      }
    }
  }
end
