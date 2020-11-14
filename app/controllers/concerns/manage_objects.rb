module ManageObjects
  extend ActiveSupport::Concern

  def category
    Category.find(params[:category_id])
  end

end
