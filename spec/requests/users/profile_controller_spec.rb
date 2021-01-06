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
              success: {type: :boolean},
              message: {type: :string},
              user: { 
                type: :object,
                properties: { 
                  id: { type: :integer },
                  email: { type: :string },
                  name: { type: :string },
                  rut: { type: :string },
                  image: {type: :string, nullable: true },
                  phone: {type: :string, nullable: true },
                  gender: {type: :string, nullable: true},
                  birthdate: {type: :string, nullable: true},
                  address: {
                    type: :object,
                    properties: {
                      street_number: {type: :string, nullable: true },
                      street: {type: :string, nullable: true },
                      condominium: {type: :string, nullable: true },
                      apartment_number: {type: :string, nullable: true }
                    }
                  },
                  commune: {
                    type: :object,
                    properties: {
                      id: {type: :integer, nullable: true },
                      name: {type: :string, nullable: true }
                    }
                  }
                }
              }
            }

          let(:'Authorization') {auth_bearer(current_user, {})}

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
  end
end

