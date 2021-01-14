require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include_context 'user_stuff'

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    it 'success register user without order!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      post :create, params: params_user
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
    end
  end

end
