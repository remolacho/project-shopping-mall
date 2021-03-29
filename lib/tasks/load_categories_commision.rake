namespace :load_categories_commision do
  desc "actualiza las tarifas por categoria desde un archivo csv"
  task run: :environment do
    file = File.read("#{Rails.root}/lib/assets/cat_commission.csv")
    counter = 0
		data_hash = CSV.parse(file, :headers => true)

    data_hash.each do |cat|
      category = Category.find(cat['id'])
      if category.present?
        category.update(commission: cat['tarifa'])
        p "categoria: #{cat['id']} tarifa: #{cat['tarifa']}"
      end
    end
  end
end