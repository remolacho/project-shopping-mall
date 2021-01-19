require 'swagger_helper'

RSpec.describe Users::ProviderSessionsController, type: :request do
  include_context 'user_stuff'

  describe 'Inicia sesion' do
    path "/users/loginProvider" do
      post 'Devuelve la sesion por red social' do
        tags 'Zofri Users'
        description 'retorna los datos usuario y en el header el JWT response.header["Authorization"]'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :order_token, in: :query, required: false, type: :string
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                uid: { type: :string },
                email: { type: :string },
                name: { type: :string },
                lastname: { type: :string },
                privider: { type: :string }
              }
            }
          },
          required: ['email', 'privider']
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string },
                   user: { type: :object,
                           properties: { id: { type: :integer },
                                         email: { type: :string },
                                         name: { type: :string },
                                         image: { type: :string, nullable: true } } }
                 }

          let(:params_user) {
            { user: { uid: 'token-facebook',
                      email: 'usertest999@email.com',
                      provider: 'facebook',
                      name: 'test_name',
                      lastname: 'test_lastname' } }
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.header['Authorization'].present?).to eq(true)
            expect(response.status).to eq(200)
          end
        end

        response 422, 'error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :object,
                              properties: {
                                fields: { type: :string }
                              } }
                 }

          let(:params_user) {
            { user: {
              uid: 'token-facebook',
              email: 'usertest@email.com',
              provider: 'facebook',
              name: 'test_name',
              lastname: 'test_lastname'
            } }
          }

          run_test!
        end

        response 403, 'error SECRET API!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'secret-api') { 'test-bad-token' }
          let(:params_user) {
            { user: {
              uid: 'token-facebook',
              email: 'usertest@email.com',
              provider: 'facebook',
              name: 'test_name',
              lastname: 'test_lastname'
            } }
          }
          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
          end
        end
      end
    end
  end
end
