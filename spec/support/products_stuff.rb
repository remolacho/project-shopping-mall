shared_context 'products_stuff' do
  let(:root_category) { root_category_1 }
  let(:category_child) { root_category.children.last }
  let(:category_child_depth_3) { categories_children_depth_3.last }
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

      product.reload
    }
  }

  let(:products_category_2) {
    FactoryBot.create_list(:product, 5,
                           :with_image,
                           category: root_category_2,
                           store: current_store,
                           brand: brands_list.first,
                           rating: 3).map { |product|
      [4500, 5000, 6500].each_with_index do |price, index|
        product_variant = FactoryBot.create(:product_variant, :is_active, product: product, price: price, is_master: index.zero?)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 100)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 12)
        FactoryBot.create(:stock_movement, :inventory_out, product_variant: product_variant, quantity: -10)
      end

      product.reload
    }
  }

  let(:products_category_child) {
    FactoryBot.create_list(:product, 5,
                           :with_image,
                           category: category_child,
                           store: current_store,
                           brand: brands_list.last,
                           rating: 3).map { |product|
      [4000, 5000, 6000].each_with_index do |price, index|
        product_variant = FactoryBot.create(:product_variant, :is_active, product: product, price: price, is_master: index.zero?)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 100)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 12)
        FactoryBot.create(:stock_movement, :inventory_out, product_variant: product_variant, quantity: -10)
      end

      product.reload
    }
  }

  let(:products_category_child_depth_3) {
    FactoryBot.create_list(:product, 5,
                           :with_image,
                           category: category_child_depth_3,
                           store: current_store,
                           brand: brands_list.last,
                           rating: 3).map { |product|
      [4000, 5000, 6000].each_with_index do |price, index|
        product_variant = FactoryBot.create(:product_variant, :is_active, product: product, price: price, is_master: index.zero?)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 100)
        FactoryBot.create(:stock_movement, product_variant: product_variant, quantity: 12)
        FactoryBot.create(:stock_movement, :inventory_out, product_variant: product_variant, quantity: -10)
      end

      product.reload
    }
  }

  let(:products_featured_category) {
    FactoryBot.create_list(:product, 5,
                           :with_image,
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

      product.reload
    }
  }

  let!(:wishlist_product) {
    current_user.wishlists.create!(product_id: products_category_2.last.id)
    current_user.wishlist.last
  }

  let(:new_collection) {
    FactoryBot.create(:collection)
  }

  let(:collection_products) {
    [products_category.last, products_category_child.first].map { |p|
      FactoryBot.create(:collection_product, product: p, collection: new_collection)
    }
  }
end
