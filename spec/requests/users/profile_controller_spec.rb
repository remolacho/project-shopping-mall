require 'swagger_helper'

RSpec.describe Users::ProfileController, type: :request do
  include_context 'user_stuff'

  describe 'Retorna data del user' do
    path "/users/profile/me" do
      get 'Devuelve el perfil' do
        tags 'Zofri Users'
        description 'retorna los datos del usuario y se debe enviar el jwt en la cabecera de solicitud "Authorization"'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: 'secret-api', in: :header

        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string },
                   user: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       email: { type: :string },
                       name: { type: :string },
                       rut: { type: :string },
                       image: { type: :string, nullable: true },
                       phone: { type: :string, nullable: true },
                       gender: { type: :string, nullable: true },
                       birthdate: { type: :string, nullable: true },
                       address: {
                         type: :object,
                         properties: {
                           street_number: { type: :string, nullable: true },
                           street: { type: :string, nullable: true },
                           condominium: { type: :string, nullable: true },
                           apartment_number: { type: :string, nullable: true }
                         }
                       },
                       commune: {
                         type: :object,
                         properties: {
                           id: { type: :integer, nullable: true },
                           name: { type: :string, nullable: true }
                         }
                       }
                     }
                   }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(body.dig('user', 'image').present?).to eq(true)
          end
        end

        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }
          run_test!
        end
      end
    end

    path "/users/profile" do
      put 'Actualiza la data del usuario' do
        tags 'Zofri Users'
        description 'retorna los datos del usuario actualizado y se debe enviar el jwt en la cabecera de solicitud "Authorization"'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header
        parameter name: :user_data, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                name: { type: :string },
                lastname: { type: :string },
                email: { type: :string }
              }
            }
          }
        }

        response 200, 'Success!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   message: { type: :string },
                   user: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       email: { type: :string },
                       name: { type: :string },
                       rut: { type: :string },
                       image: { type: :string, nullable: true },
                       phone: { type: :string, nullable: true },
                       gender: { type: :string, nullable: true },
                       birthdate: { type: :string, nullable: true },
                       address: {
                         type: :object,
                         properties: {
                           street_number: { type: :string, nullable: true },
                           street: { type: :string, nullable: true },
                           condominium: { type: :string, nullable: true },
                           apartment_number: { type: :string, nullable: true }
                         }
                       },
                       commune: {
                         type: :object,
                         properties: {
                           id: { type: :integer, nullable: true },
                           name: { type: :string, nullable: true }
                         }
                       }
                     }
                   }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:user_data) { { user: { name: 'Paulo' } } }

          run_test! do |response|
            expected_user = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(expected_user['user']['name']).to eq('Paulo')
          end
        end

        response 401, 'JWT error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:user_data) { { user: { name: 'Paulo' } } }

          run_test!
        end
      end
    end
  end
end
