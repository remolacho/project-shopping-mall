class AddDataSlugToBrands < ActiveRecord::Migration[6.0]
  def change
    Brand.find_each(batch_size: 1000) do |brand|
      next unless brand.name.present?
      brand.name = brand.name.strip
      brand.slug = brand.name.str_slug
      brand.save!
      puts brand.slug
      puts '***************************************************************************'
    end
  end
end
