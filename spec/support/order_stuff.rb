shared_context 'order_stuff' do
  let(:payment_method) { FactoryBot.create(:payment_method) }

  let(:current_order) {
    FactoryBot.create(:order, :with_user, user: User.find_by(email: 'usertest@email.com'))
  }

  let(:current_order_with_user) {
    FactoryBot.create(:order, :with_user, user: User.find_by(email: 'usertest@email.com'))
  }

  let(:current_order_without_user) {
    FactoryBot.create(:order)
  }

  let(:list_order_item) {
    products = Product.includes(:product_variants, :store).limit(3)
    products.map do |product|
      product_variant = product.product_variants.sample(random: SecureRandom)
      FactoryBot.create(:order_item, product_variant: product_variant, order: current_order, store: product.store)
    end
  }

  let(:list_order_item_with_discount) {
    ProductVariant.update_all(discount_value: 800)
    products = Product.includes(:product_variants, :store).limit(3)
    products.map do |product|
      product_variant = product.product_variants.sample(random: SecureRandom)
      FactoryBot.create(:order_item, product_variant: product_variant, order: current_order, store: product.store)
    end
  }

  let(:list_order_item_consolidate) {
    products = Product.includes(:product_variants, :store).limit(3)
    order_items = products.map do |product|
      product_variant = product.product_variants.sample(random: SecureRandom)
      FactoryBot.create(:order_item, product_variant: product_variant, order: current_order, store: product.store)
    end

    current_order.consolidate_payment_total
    order_items
  }

  let(:list_order_item_many_stores) {
    products = Store.limit(2).map{|store|
      store.products.includes(:product_variants, :store).limit(2)
    }.flatten

    order_items = products.map do |product|
      product_variant = product.product_variants.sample(random: SecureRandom)
      FactoryBot.create(:order_item, product_variant: product_variant, order: current_order, store: product.store)
    end

    current_order.consolidate_payment_total
    order_items
  }

  let(:promo_code) { FactoryBot.create(:promotion, :percentage) }

  let(:promotion_adjustment){

    total_pay = list_order_item_consolidate.map{ |order_item|
      (order_item.unit_value * order_item.item_qty).to_f
    }.sum

    total_percentage = ((total_pay * promo_code.promotion_value) / 100) * -1

    promo_code.order_adjustments.create(order_id: current_order.id,
                                        value: total_percentage)
  }

  let(:shipment_data_delivey){
    {shipment: {
        commune_id: commune.id,
        shipment_id: shipment_method.id,
        in_site: false,
        delivery_price: 2500,
        latitude: 0,
        longitude: 0,
        apartment_number: '',
        condominium: '',
        street: 'test street',
        street_number: '2568',
        comment: 'es una prueba de direccion'
    }}
  }

  let(:shipment_data_in_site){
    {shipment: {
        shipment_id: shipment_method_in_site.id,
        delivery_price: 0,
        latitude: 0,
        longitude: 0,
        firstname: 'test firstname',
        lastname: 'test lastname',
        commune_id: Commune.last.id
    }}
  }
end
