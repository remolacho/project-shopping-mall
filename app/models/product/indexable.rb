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

        attribute :strore do
          store.name
        end

        attribute :prices do
          product_variants.map(&:price)
        end

        attribute :skus do
          product_variants.map(&:sku)
        end

        attribute :internal_skus do
          product_variants.map(&:internal_sku)
        end

        attribute :rating

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
      return true if Rails.env.test?

      index!
    end

    private

    def is_active?
      product_variants.any?{ |variant| variant.active } && !hide_from_results
    end
  end
end
