class AddDataSlugToProducts < ActiveRecord::Migration[6.0]
  def change
    Product.all.each do |product|
      product.slug = product.name.str_slug
      product.save
      puts product.slug
      puts '***************************************************************************'
    end
  end
end
