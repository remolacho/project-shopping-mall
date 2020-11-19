shared_context 'order_stuff' do

  let(:current_order) {
    FactoryBot.create(:order)
  }

  let(:current_order_with_user) {
    FactoryBot.create(:order, :with_user, user: User.find_by(email: 'usertest@email.com'))
  }

  let(:list_order_item) {
    products = Product.includes(:product_variants, :store).limit(3)
    products.map do |product|
      product_variant = product.product_variants.sample(random: SecureRandom)
      FactoryBot.create(:order_item, product_variant: product_variant, order: current_order, store: product.store )
    end
  }
end
