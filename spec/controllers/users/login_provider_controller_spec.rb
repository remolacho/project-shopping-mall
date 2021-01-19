require 'rails_helper'

RSpec.describe Users::ProviderSessionsController, type: :controller do
  include_context 'user_stuff'

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:params_user) {
    { user: {
      uid: 'token-facebook',
      email: 'usertest@email.com',
      provider: 'facebook',
      name: 'test_name',
      lastname: 'test_lastname'
    } }
  }

  describe "POST #create" do
    it 'error login email in use!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      post :create, params: params_user
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(false)
    end

    it 'error login uid is empty!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      params_user[:user].merge!(uid: '', email: 'test33@test.com')
      post :create, params: params_user
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(false)
    end

    it 'error login provider is empty!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      params_user[:user].merge!(provider: '', email: 'test33@test.com')
      post :create, params: params_user
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(false)
    end

    it 'success login create!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      params_user[:user].merge!(email: 'test33@test.com')
      post :create, params: params_user
      body = JSON.parse(response.body)
      jwt = response.header['Authorization']
      expect(body.dig('success')).to eq(true)
      expect(jwt.present?).to eq(true)
    end

    it 'success login find!!!' do
      User.create!(name: 'test_name',
                   lastname: 'test_lastname',
                   uid: 'token-facebook',
                   email: 'test33@test.com',
                   provider: 'facebook',
                   password: 'passwordtest123',
                   password_confirmation: 'passwordtest123')

      expect(User.find_by(email: 'test33@test.com').present?).to eq(true)

      request.headers['secret-api'] = ENV['SECRET_API']
      params_user[:user].merge!(email: 'test33@test.com')
      post :create, params: params_user
      body = JSON.parse(response.body)
      jwt = response.header['Authorization']
      expect(body.dig('success')).to eq(true)
      expect(jwt.present?).to eq(true)
    end
  end
end
