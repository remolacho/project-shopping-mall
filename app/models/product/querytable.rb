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

      def self.list
        joins(:brand, :store, :product_variants, :category)
          .select("products.id, categories.name::json->> '#{I18n.locale.to_s}' as category_name,
                      product_variants.price, brands.name as brand_name,
                      stores.name as store_name,
                      product_variants.is_master, product_variants.active as variant_active,
                      products.rating,
                      products.name_translations,
                      products.short_description_translations,
                      products.featured")
          .where(product_variants: { is_master: true, active: true })
          .where(stores: { active: true })
      end

      def self.counter_by_category(categories_ids)
        joins(:store, :product_variants)
          .where(product_variants: { is_master: true, active: true })
          .where(stores: { active: true })
          .where(category_id: categories_ids)
          .count
      end
    end

  end
end
