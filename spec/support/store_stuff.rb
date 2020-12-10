shared_context 'store_stuff' do
  let!(:store) {
    FactoryBot.create(:store,
                      :is_active,
                      commune: Commune.first,
                      category: Category.first,
                      company: Company.first)
  }

  let(:store_inactive) {
    FactoryBot.create(:store,
                      :is_inactive,
                      commune: Commune.first,
                      category: Category.first,
                      company: Company.first)
  }
end
