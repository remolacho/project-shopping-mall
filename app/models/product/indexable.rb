class Product
  module Indexable
    extend ActiveSupport::Concern
    include AlgoliaSearch
    include Rails.application.routes.url_helpers

    included do
      after_update :reindex

      algoliasearch per_environment: true, auto_index: false do
        attribute :id
        attribute :slug
        attribute :category_id
        attribute :store_id
        attribute :brand_id

        attribute :image_url do
          rails_blob_url(image, disposition: "attachment", only_path: true) if image.attached?
        end

        attribute :brand do
          brand.name
        end

        attribute :category_es do
          category.name['es']
        end

        attribute :name_es do
          name_translations['es']
        end

        attribute :short_description_es do
          short_description_translations['es']
        end

        attribute :store do
          store.name
        end

        attribute :prices do
          product_variants.map(&:price)
        end

        attribute :discount_prices do
          product_variants.map(&:discount_value)
        end

        attribute :skus do
          product_variants.map(&:sku)
        end

        attribute :total_stock do
          product_variants.map(&:current_stock).sum
        end

        attribute :rating

        attribute :price do
          assign_price
        end

        tags do
          ["active_#{is_active?}", "hide_result_#{hide_from_results}"]
        end

        attributesToHighlight ['name_es']
        highlightPreTag '<strong>'
        highlightPostTag '</strong>'
        searchableAttributes ['name_es', 'short_description_es', 'brand', 'category_es', 'prices']
        attributesForFaceting ['brand', 'category_es']
        hitsPerPage ENV['ALGOLIA_PER_PAGE'].to_i
        paginationLimitedTo ENV['ALGOLIA_LIMIT'].to_i
      end
    end

    def reindex
      return true unless Rails.env.production?

      index!
    end

    private

    def is_active?
      has_variant = product_variants.detect { |variant| variant.is_master && variant.active }.present?
      has_variant && !hide_from_results && active && assign_price.present?
    end

    def assign_price
      return @price if @price.present?

      product_variant = product_variants.where(is_master: true).where.not(current_stock: 0, price: 0).first

      @price = if product_variant.present?
                 product_variant.price
               else
                 product_variant = product_variants.where.not(current_stock: 0, price: 0).order(price: :asc).first
                 product_variant.try(:price)
               end
    end
  end
end
