# frozen_string_literal: true

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
        attribute :rating

        attribute :brand do
          brand.name
        end

        attribute :category_es do
          category.name['es']
        end

        attribute :category_parent_id do
          category.parent_id
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

        attribute :image_url do
          rails_blob_url(image, disposition: 'attachment', only_path: true) if image.attached?
        end

        attribute :total_stock do
          product_variants.sum(&:current_stock)
        end

        attribute :has_master do
          product_variants.detect { |variant| variant.is_master && variant.active }.present?
        end

        attribute :price do
          assign_price
        end

        attribute :discount_price do
          assign_discount_price
        end

        attribute :active do
          is_active?
        end

        attributesToHighlight ['name_es']
        highlightPreTag '<strong>'
        highlightPostTag '</strong>'
        searchableAttributes %w[name_es short_description_es brand category_es category_parent_id prices price active]
        attributesForFaceting %w[brand category_es price active]
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
      has_stock   = !product_variants.sum(&:current_stock).zero?

      has_variant &&
        has_stock &&
        active &&
        !hide_from_results &&
        !assign_price.zero? &&
        image.attached? &&
        store.active
    end

    def assign_price
      return @price if @price.present?

      product_variant = product_variants.where(is_master: true).where.not(price: 0).first

      @price = if product_variant.present?
                 product_variant.price
               else
                 product_variant = product_variants.where.not(price: 0).order(price: :asc).first
                 product_variant.try(:price) || 0
               end
    end

    def assign_discount_price
      return @discount_value if @discount_value.present?

      product_variant = product_variants.where(is_master: true).where.not(discount_value: 0).first

      @discount_value = if product_variant.present?
                          product_variant.discount_value
                        else
                          product_variant = product_variants.where.not(price: 0).order(discount_value: :asc).first
                          product_variant.try(:discount_value) || 0
                        end
    end
  end
end
