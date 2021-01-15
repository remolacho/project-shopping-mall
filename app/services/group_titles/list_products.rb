# hereda de Categories::ListProducts y sobreescribe el metodo de jerarquia para que adapte
# al del titulo y sus categorias hijas

class GroupTitles::ListProducts < ::Categories::ListProducts

  attr_accessor :group_title

  def initialize(group_title:, data:)
    super(category: nil, data: data)
    @group_title = group_title
  end

  def perform
    products_group = group_list
    products_group = filter_brand(products_group)
    products_group = filter_rating(products_group)
    products_group = filter_prices(products_group)
    products_group = pagination(products_group)

    {
      success: true,
      per_page: ENV['PER_PAGE'].to_i,
      total_pages: products_group.total_pages,
      total_objects: products_group.total_count,
      category: ::Categories::GroupTitlesSerializer.new(group_title),
      products: serializer(products_group)
    }
  end

  private

  def hierarchy
    categories = group_title.categories
    raise ActiveRecord::RecordNotFound, 'No hay categorias para este titulo' unless categories.present?
    categories.map(&:id) | categories.map{|category| category.descendant_ids}.flatten
  end
end
