require 'swagger_helper'

RSpec.describe Users::SessionsController, type: :request do
  include_context 'user_stuff'

  describe 'Inicia sesion' do
    path "/login" do
      post 'Devuelve la sesion' do
        tags 'Zofri Users'
        description 'retorna los datos usuario y en el header el JWT response.header["Authorization"]'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              }
            }
          },
          required: [ 'email', 'password' ]
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean},
                   message: {type: :string},
                   user: { type: :object,
                           properties: { id: { type: :integer },
                                         email: { type: :string },
                                         name: { type: :string },
                                         image: {type: :string, nullable: true }}
                   }
                 }

          let(:params_user){ {user: {email: 'usertest@email.com', password: 'passwordtest123' }} }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.header['Authorization'].present?).to eq(true)
            expect(response.status).to eq(200)
          end
        end

        response 401, 'error!!!' do
          schema type: :object, properties: { error: {type: :string} }

          let(:params_user){ {user: {email: 'usertest@email.com', password: 'passwordtest1236' }} }
          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.key?('error')).to eq(true)
          end

          let(:params_user){ {user: {email: 'usertest@email1.com', password: 'passwordtest123' }} }
          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.key?('error')).to eq(true)
          end
        end

        response 403, 'error SECRET API!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:'secret-api') { 'test-bad-token' }
          let(:params_user){ {user: {email: 'usertest@email.com', password: 'passwordtest123' }} }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
          end
        end

      end
    end
  end
end
