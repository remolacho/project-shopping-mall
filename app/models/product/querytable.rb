# frozen_string_literal: true

class Product
  module Querytable
    extend ActiveSupport::Concern

    included do
      def self.list
        joins(:brand, :store, :product_variants, :category)
          .select("products.id, categories.name::json->> '#{I18n.locale.to_s}' as category_name,
                   product_variants.price, brands.name as brand_name, product_variants.discount_value,
                   product_variants.price, products.brand_id, brands.name as brand_name, product_variants.discount_value,
                   stores.name as store_name,
                   product_variants.is_master, product_variants.active as variant_active,
                   products.rating,
                   products.name_translations,
                   products.short_description_translations,
                   products.featured")
          .where(products: { can_published: true })
          .where(product_variants: { is_master: true, active: true, deleted_at: nil })
          .where(stores: { active: true })
      end

      def self.list_prices
        joins(:brand, :store, :product_variants, :category)
          .select('DISTINCT(product_variants.price) price')
          .where(product_variants: { is_master: true, active: true, deleted_at: nil })
          .where(products: { can_published: true })
          .order('product_variants.price ASC')
      end

      def self.counter_categories(limit: 5)
        select('categories.id, categories.name as category_name, categories.slug, COUNT(categories.id) AS total')
          .joins(:category)
          .group('categories.id')
          .order('total DESC')
          .limit(limit)
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
          .where(product_variants: { is_master: true, active: true, deleted_at: nil })
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
          .where(product_variants: { active: true, deleted_at: nil })
          .where(products: { id: products_ids })
      end

      def self.discount_not_nil
        where.not(product_variants: { discount_value: nil })
          .where(product_variants: { active: true, deleted_at: nil })
      end

      def self.group_stock
        joins(:brand, :store, :product_variants)
          .select('products.id, SUM(product_variants.current_stock) AS total_stock')
          .where(product_variants: { active: true, deleted_at: nil })
          .where(stores: { active: true })
          .where(products: { active: true })
          .group('products.id')
          .having('SUM(product_variants.current_stock) > 0')
      end

      def self.with_discount
        having('SUM(product_variants.discount_value) > 0')
      end

      def self.most_valued
        where('products.rating >= 4')
      end

      def self.counter_by_category(categories_ids)
        where(can_published: true, category_id: categories_ids).count
      end

      def self.counter_by_brand(brand_id)
        where(can_published: true, brand_id: brand_id).count
      end
    end
  end
end
