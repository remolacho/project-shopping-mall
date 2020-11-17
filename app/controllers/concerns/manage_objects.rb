module ManageObjects
  extend ActiveSupport::Concern

  def category
    Category.find(params[:category_id])
  end

  def product
    Product.find(params[:product_id])
  end

end
