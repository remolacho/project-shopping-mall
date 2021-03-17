class Stores::CategoriesList
  attr_accessor :store, :categories

  def initialize(store:, category: nil)
    @store = store
    @categories = category ? category.children : Category.roots
  end

  def perform
    array_categories = []

    categories.each do |category|
      categories_ids = hierarchy(category)
      products_count = store.products.counter_by_category(categories_ids)

      next if products_count.zero?

      array_categories << {
        id: category.id,
        name: category.name[I18n.locale.to_s],
        slug: category.slug,
        products_count: products_count,
        is_visible: true
      }
    end

    array_categories
  end

  private

  # Overrides method of concerns
  def hierarchy(category)
    [category.id] | category.descendant_ids
  end
end
