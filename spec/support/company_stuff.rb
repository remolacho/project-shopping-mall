shared_context 'company_stuff' do
  let!(:user) { FactoryBot.create(:user, :is_admin, email: 'test1@etinertest.com') }
  let!(:country) { FactoryBot.create(:country) }
  let!(:region) { FactoryBot.create(:region, country: country) }
  let!(:commune) { FactoryBot.create(:commune, region: region) }
  let!(:company) { FactoryBot.create(:company, user: user, country: country) }
end
