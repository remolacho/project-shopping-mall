class AddColumnNameTranslateToProductVariants < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute("create extension if not exists hstore;")
    add_column :product_variants, :name_translations, 'hstore'
    add_column :product_variants, :short_description_translations, 'hstore'
    remove_column :product_variants, :name
    remove_column :product_variants, :short_description
  end
end
