# frozen_string_literal: true

module GroupTitles
  class List
    include Rails.application.routes.url_helpers

    attr_accessor :section

    def initialize(section:)
      @section = section
    end

    def perform
      {
        success: true,
        section: section,
        titles: allowed_titles
      }
    end

    private

    def allowed_titles
      titles = group_titles.map do |gt|
        result_hierarchy = hierarchy_group(gt)
        next nil unless result_hierarchy.present?
        next nil unless has_products?(result_hierarchy)

        { id: gt.id, name: gt.name, slug: gt.slug, icon_url: icon_url(gt), image_url: image_url(gt) }
      end

      titles.compact
    end

    def group_titles
      @group_titles ||= GroupTitle.all
    end

    def hierarchy_group(group_title)
      categories = group_title.categories.uniq
      return unless categories.present?

      categories.map(&:id) | categories.map(&:descendant_ids).flatten
    end

    def has_products?(hierarchy)
      records = case section
                when 'discount'
                  Product.select('COUNT(products.id) as total').joins(:product_variants)
                         .published.by_hierarchy(hierarchy).with_discount.group('products.id')
                when 'rating'
                  Product.published.by_hierarchy(hierarchy).most_valued
                when 'recents'
                  Product.published.by_hierarchy(hierarchy).last_days(days: 30)
                end

      !records.empty?
    end

    def image_url(object)
      polymorphic_url(object.image, host: ENV['HOST_IMAGES']) if object.image.attached?
    end

    def icon_url(object)
      polymorphic_url(object.icon, host: ENV['HOST_IMAGES']) if object.icon.attached?
    end
  end
end
