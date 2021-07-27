# frozen_string_literal: true
require 'swagger_helper'

RSpec.describe Users::PasswordController, type: :request do
  include_context 'user_stuff'

  describe 'Recupera el password' do
    path '/users/password/recover' do
      post 'Devuelve un correo con el token para recuperar el pass' do
        tags 'Zofri Users'
        description 'Retorna un correo con el token para recuoerar el pass'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string }
              }
            }
          },
          required: ['email']
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string }
                 }

          let(:params_user) { { user: { email: 'usertest@email.com' } } }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(true)
          end
        end

        response 404, 'error not found!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:params_user) { { user: { email: 'usertest1@email.com' } } }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(false)
          end
        end

        response 403, 'error SECRET API!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'secret-api') { 'test-bad-token' }
          let(:params_user) { { user: { email: 'usertest@email.com', password: 'passwordtest123' } } }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(false)
          end
        end
      end
    end
  end
end
