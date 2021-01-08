class AddDataSlugToRepositoryProducts < ActiveRecord::Migration[6.0]
  def change
    RepositoryProduct.find_each(batch_size: 1000) do |repository|
      next unless repository.name.present?
      repository.name = {es: repository.name['es'].strip}
      repository.slug = repository.name['es'].str_slug
      repository.brand = repository.brand.strip if repository.brand.present?
      repository.save!
      puts repository.slug
      puts '***************************************************************************'
    end
  end
end
