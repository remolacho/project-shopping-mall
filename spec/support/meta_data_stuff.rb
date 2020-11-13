shared_context 'meta_data_stuff' do
  let!(:root_category_1) { FactoryBot.create(:category, depth: 1) }
  let!(:root_category_2) { FactoryBot.create(:category, depth: 1) }

  let!(:categories_list_1) {
    FactoryBot.create_list(:category, 3, depth: 2).map{ |category|
      category.parent = root_category_1
      category.save
    }
  }

  let!(:categories_list_2) {
    FactoryBot.create_list(:category, 3, depth: 2).map{ |category|
      category.parent = root_category_2
      category.save
    }
  }

  let!(:brand_list){
    FactoryBot.create_list(:brand, 5).map{ |brand|
      FactoryBot.create(:brand_category, category: root_category_1, brand: brand)
    }
  }

  let!(:option_types){
    FactoryBot.create_list(:option_type, 5).map{ |option|
      FactoryBot.create(:category_option_type, category: root_category_1, option_type: option)
      FactoryBot.create_list(:option_value, 5, option_type: option)
    }
  }
end
