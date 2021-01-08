class AddColumnNameTranslateToProducts < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.execute("create extension if not exists hstore;")
    add_column :products, :name_translations, 'hstore'
    add_column :products, :short_description_translations, 'hstore'
    remove_column :products, :name
    remove_column :products, :short_description
    remove_column :products, :description_translate
  end
end
