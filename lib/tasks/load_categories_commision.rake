namespace :load_categories_commision do
  desc "actualiza las tarifas por categoria desde un archivo csv"
  task run: :environment do
    file = File.read("#{Rails.root}/lib/assets/cat_commission.csv")
    counter = 0
		data_hash = CSV.parse(file, :headers => true)

    p "ETAPA 1: Asignacion de comision por csv"
    data_hash.each do |cat|
      category = Category.find_by_id(cat['id'])
      if category.present?
        category.update(commission: cat['tarifa'])
        p "categoria: #{cat['id']} tarifa: #{cat['tarifa']}"
      end
    end

    p "ETAPA 2: Asignacion de comision por parents"
    Category.where(commission: 0).each do |category|
      commission = category.path.where.not(commission: 0.0).reverse_order.first.try(:commission)
      if commission.present?
        category.update(commission: commission)
        p "categoria: #{category.id} tarifa: #{commission}"
      end
    end

  end
end