shared_context 'products_stuff' do

  let(:root_category) { Category.first }
  let(:category_child){ root_category.children.last }
  let(:current_store) { Store.first }
  let(:brands_list) { root_category.brands }

  let!(:products_category) {
    FactoryBot.create_list(:product, 5,
                           :with_image,
                           category: root_category,
                           store: current_store,
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

  let!(:products_category_child) {
    FactoryBot.create_list(:product, 5,
                           category: category_child,
                           store: current_store,
                           brand: brands_list.last,
                           rating: 4).map { |product|

      [4000, 5000, 6000].each_with_index do |price, index|
        product_variant = FactoryBot.create(:product_variant, :is_active, product: product, price: price, is_master: index.zero?)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 100)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 12)
        FactoryBot.create(:stock_movement, :inventory_out, product_variant: product_variant, quantity: -10)
      end

      product
    }
  }

  let(:products_featured_category) {
    FactoryBot.create_list(:product, 5,
                           :is_featured,
                           category: root_category,
                           store: current_store,
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

end

