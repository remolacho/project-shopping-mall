class Product
  module Querytable
    extend ActiveSupport::Concern

    included do
      def self.counter_categories(limit: 5)
        select('categories.id, categories.name as category_name, categories.slug, COUNT(categories.id) AS total')
          .joins(:category)
          .group('categories.id')
          .order('total DESC')
          .limit(limit)
      end

      def self.list_prices
        joins(:brand, :store, :product_variants, :category)
          .select("DISTINCT(product_variants.price) price")
          .where(product_variants: { is_master: true, active: true })
          .where(stores: { active: true })
          .where(products: { active: true })
          .order('product_variants.price ASC')
      end

      def self.list_by_ids(products_ids)
        joins(:brand, :store, :product_variants, :category)
          .select("products.id, categories.name::json->> '#{I18n.locale.to_s}' as category_name,
                   product_variants.price, brands.name as brand_name, product_variants.discount_value,
                   stores.name as store_name,
                   product_variants.is_master, product_variants.active as variant_active,
                   products.rating,
                   products.name_translations,
                   products.short_description_translations,
                   products.featured")
          .where(product_variants: { is_master: true, active: true })
          .where(products: { id: products_ids })
      end

      def self.list_witout_master(products_ids)
        joins(:brand, :store, :product_variants, :category)
          .select("products.id, categories.name::json->> '#{I18n.locale.to_s}' as category_name,
                   product_variants.price, brands.name as brand_name, product_variants.discount_value,
                   stores.name as store_name,
                   product_variants.is_master, product_variants.active as variant_active,
                   products.rating,
                   products.name_translations,
                   products.short_description_translations,
                   products.featured")
          .where(product_variants: { active: true })
          .where(products: { id: products_ids })
      end

      def self.discount_not_nil
        where.not(product_variants: { discount_value: nil })
      end

      def self.group_stock
        joins(:brand, :store, :product_variants)
          .select("products.id, SUM(product_variants.current_stock) AS total_stock")
          .where(product_variants: { active: true })
          .where(stores: { active: true })
          .where(products: { active: true })
          .group("products.id")
          .having("SUM(product_variants.current_stock) > 0")
      end

      def self.with_discount
        having("SUM(product_variants.discount_value) > 0")
      end

      def self.counter_by_category(categories_ids)
        group_stock.where(category_id: categories_ids).ids.count
      end

      def self.counter_by_brand(brand_id)
        group_stock.where(brand_id: brand_id).ids.count
      end
    end
  end
end
