# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Users::PasswordController, type: :request do
  include_context 'user_stuff'

  describe 'Cambia el password' do
    path '/users/password/change' do
      post 'Devuelve el reseteo del password' do
        tags 'Zofri Users'
        description 'Devuelve el reseteo del password y un atributo  redirect_to: store-owner/zofri-shop que indica
a donde devera devolver la app la peticion'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                password: { type: :string },
                password_confirmation: { type: :string },
                token: { type: :string }
              }
            }
          },
          required: ['password', 'password_confirmation', 'token']
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string },
                   redirect_to: { type: :string }
                 }

          let(:params_user) {
            create_user.generate_password_token!(1.day.from_now)
            create_user.reload

            { user: { password: 'new-password',
                      password_confirmation: 'new-password',
                      token: create_user.reset_password_token } }
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(true)
          end
        end

        response 422, 'error password!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false  },
                   message: { type: :object,
                              properties: {
                                fields: { type: :string }
                              } }
                 }

          let(:params_user) {
            create_user.generate_password_token!(1.day.from_now)
            create_user.reload

            { user: { password: 'new-password',
                      password_confirmation: 'new-password-other',
                      token: create_user.reset_password_token } }
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(false)
          end
        end

        response 403, 'error token expired!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false  },
                   message: { type: :string }
                 }

          let(:params_user) {
            create_user.generate_password_token!(-1.day.from_now)
            create_user.reload

            { user: { password: 'new-password',
                      password_confirmation: 'new-password',
                      token: create_user.reset_password_token } }
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body['success']).to eq(false)
          end
        end
      end
    end
  end
end
