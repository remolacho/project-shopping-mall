shared_context 'user_stuff' do

  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_reset!
  end

  let!(:create_user) {
    User.create!({ name: 'usertest',
                   lastname: 'userTest',
                   email: 'usertest@email.com',
                   password: 'passwordtest123',
                   password_confirmation: 'passwordtest123',
                   rut: '1231321313',
                   image: fixture_file_upload('/files/avatar.png', 'image/png')})
  }

  let(:create_user_2) {
    User.create!({ name: 'usertest2',
                   lastname: 'userTest2',
                   email: 'usertest2@email.com',
                   password: 'passwordtest123',
                   password_confirmation: 'passwordtest123',
                   rut: '12313213132',
                   image: fixture_file_upload('/files/avatar.png', 'image/png')})
  }

  let(:current_user) { User.find_by(email: 'usertest@email.com') }

  let(:current_user_2) { create_user_2 }

  let(:params_user){
    {
      user: { name: 'usertest2',
              lastname: 'userTest2',
              email: 'usertest2@email.com',
              password: 'passwordtest123',
              password_confirmation: 'passwordtest123',
              rut: '12313213132',
              image: fixture_file_upload('/files/avatar.png', 'image/png')}
    }
  }

  let(:'secret-api') { ENV['SECRET_API'] }

end
