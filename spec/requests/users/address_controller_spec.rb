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
              address: {
                apartment_number: {type: :string, nullable: true},
                comment: {type: :string},
                comune: {type: :string, nullable: true},
                condominium: {type: :string, nullable: true},
                firstname: {type: :string, nullable: true},
                id: {type: :integer},
                lastname: {type: :string, nullable: true},
                latitude: {type: :string, nullable: true},
                longitude: {type: :string, nullable: true},
                phone: {type: :string, nullable: true},
                street: {type: :string},
                street_number: {type: :string},
              }
            }

          let(:'Authorization') {auth_bearer(current_user, {})}

          run_test! do |response|
            expected_address = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(expected_address['address']['street']).to eq('Park Avenue')
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
              address: {
                apartment_number: {type: :string, nullable: true},
                comment: {type: :string},
                comune: {type: :string, nullable: true},
                condominium: {type: :string, nullable: true},
                firstname: {type: :string, nullable: true},
                id: {type: :integer},
                lastname: {type: :string, nullable: true},
                latitude: {type: :string, nullable: true},
                longitude: {type: :string, nullable: true},
                phone: {type: :string, nullable: true},
                street: {type: :string},
                street_number: {type: :string},
              }
            }

          let(:'Authorization') {auth_bearer(current_user, {})}
          let(:address_id) { create_address.id }
          let(:params_address){ params_address_2 }

          run_test! do |response|
            expected_address = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(expected_address['address']['street']).to eq('Other Park Avenue')
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
