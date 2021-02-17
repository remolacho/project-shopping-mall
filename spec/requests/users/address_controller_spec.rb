require 'swagger_helper'

RSpec.describe Users::ProfileController, type: :request do
  include_context 'user_stuff'
  include_context 'address_stuff'

  describe 'Crea una nueva dirección del usuario' do
    
    path '/users/address' do
      post 'Crea una nueva dirección' do
        tags 'Zofri Address'
        description 'Crea una nueva dirección y se debe enviar el jwt en la cabecera de solicitud "Authorization"'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :params_address, in: :body, schema: {
          type: :object,
          properties: {
            address: {
              type: :object,
              properties: {
                commune_id: { type: :integer },
                street: { type: :string },
                street_number: { type: :string },
                phone: { type: :string },
                comment: { type: :string }
              }
            }
          }
        }

        response 200, 'success' do
          schema type: :object,
            properties: {
              success: {type: :boolean},
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

          let(:'Authorization') {auth_bearer(current_user, {})}

          run_test! do |response|
            expected_address = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(expected_address['user']['address']['street']).to eq('Park Avenue')
          end
        end

        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }

          run_test!
        end
      end
    end

  end

  describe 'Actualiza una dirección del usuario' do

    path '/users/address/{address_id}' do
      put 'Actualiza una dirección' do
        tags 'Zofri Address'
        description 'Actualiza una dirección y se debe enviar el jwt en la cabecera de solicitud "Authorization"'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :address_id, in: :path
        parameter name: :params_address, in: :body, schema: {
          type: :object,
          properties: {
            address: {
              type: :object,
              properties: {
                commune_id: { type: :integer },
                street: { type: :string },
                street_number: { type: :string },
                phone: { type: :string },
                comment: { type: :string }
              }
            }
          }
        }

        response 200, 'success' do
          schema type: :object,
            properties: {
              success: {type: :boolean},
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

          let(:'Authorization') {auth_bearer(current_user, {})}
          let(:address_id) { create_address.id }
          let(:params_address){ params_address_2 }

          run_test! do |response|
            expected_address = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(expected_address['user']['address']['street']).to eq('Other Park Avenue')
          end

        end


        response 401, 'Jwt error!!!' do
          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:address_id) { create_address.id }
          let(:params_address){ params_address_2 }

          run_test!
        end
      end
    end

  end

end
