module Bills
  class List

    attr_accessor :filter

    def initialize(filter:)
      @filter = filter&.deep_symbolize_keys
    end

    def call
      Struct.new(:success,
                 :items,
                 :message).new(true, billing_to_json(set_billding), nil)
    rescue StandardError => e
      Struct.new(:success, :items, :message).new(false, [], e.to_s)
    end

    private

    def set_billding
      billding = bill_order_items
      billding = filter_date_billing(billding)
      sort_billing(billding)
    end

    def billing_to_json(billing)
      billing.map do |item|
        {
          id: item.id,
          bill_store_id: item.bill_store_id,
          rut: item.rut,
          store_name: item.store_name,
          ticket_number: item.ticket_number,
          ticket_date: item.ticket_date,
          num_module: item.num_module,
          order_number_ticket: item.order_number_ticket,
          store_orders_order_number: item.store_orders_order_number,
          sku: item.sku,
          name: item.name_translations[I18n.locale.to_s].presence || item.name_translations.values.first,
          quantity: item.quantity,
          unit_value: item.unit_value,
          total: item.quantity * item.unit_value,
          category_id: item.category_id,
          category_name: item.category_name[I18n.locale.to_s].presence || item.category_name.values.first,
          commission: item.zofri_commission_percentage,
          total_zofrishop: ((item.quantity * item.unit_value) * (item.zofri_commission_percentage / 100).to_f).round(2),
          seller_income: item.seller_income.to_i,
          payment_method: item.payment_method,
          percentage_mp: item.mp_commission_percentage,
          commission_mp: ((item.quantity * item.unit_value) * (item.mp_commission_percentage / 100).to_f).round(2)
        }
      end
    end

    def bill_order_items
      BillStore.joins(store: :company)
               .joins('JOIN "store_modules" ON "store_modules"."id" = "bill_stores"."store_module_id"')
               .joins('JOIN "bill_store_order_items" ON "bill_store_order_items"."bill_store_id" = "bill_stores"."id"')
               .joins('JOIN "order_items" ON "order_items"."id" = "bill_store_order_items"."order_item_id" ')
               .joins('JOIN "orders" ON "orders"."id" = "order_items"."order_id"')
               .joins('JOIN "store_orders" ON "store_orders"."id" = "order_items"."store_order_id"')
               .joins('JOIN "product_variants" ON "product_variants"."id" = "order_items"."product_variant_id"')
               .joins('JOIN "product_variants" "product_variants_order_items_join" ON "product_variants_order_items_join"."id" = "order_items"."product_variant_id"')
               .joins('JOIN "products" ON "products"."id" = "product_variants_order_items_join"."product_id"')
               .joins('JOIN "categories" ON "categories"."id" = "products"."category_id"')
               .select('bill_stores.id as bill_store_id, bill_stores.ticket_number, bill_stores.ticket_date,
                        store_modules.num_module, bill_store_order_items.id, orders.number_ticket as order_number_ticket,
                        store_orders.order_number as store_orders_order_number, product_variants.sku,
                        product_variants.name_translations, bill_store_order_items.quantity, order_items.unit_value,
                        categories.id as category_id, categories.name as category_name, categories.commission,
                        bill_store_order_items.seller_income, bill_store_order_items.mp_commission_percentage, bill_store_order_items.zofri_commission_percentage, bill_stores.payment_method, stores.name as store_name, companies.rut')
    end

    def filter_date_billing(billing)
      billing.where('bill_stores.ticket_date BETWEEN ? AND ?', filter[:from], filter[:to])
    end

    def sort_billing(billing)
      billing.order('store_name ASC, ticket_date DESC')
    end
  end
end

