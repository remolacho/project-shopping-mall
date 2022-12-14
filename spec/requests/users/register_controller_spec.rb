require 'swagger_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe 'Retorna data del user' do
    path "/signup" do
      post 'Registra el nuevo usuario' do
        tags 'Zofri Users'
        description 'retorna los datos usuario y en el header el JWT response.header["Authorization"]'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :order_token, in: :query, required: false, type: :string
        parameter name: :user_register, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string },
                name: { type: :string },
                lastname: { type: :string },
                gender: { type: :string, nullable: true },
                birthdate: { type: :date, nullable: true },
                password_confirmation: { type: :string },
                rut: { type: :string },
                image: { type: :string, format: :binary }
              }
            }
          },
          required: ['name', 'email', 'password', 'password_confirmation']
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
                                         rut: { type: :string },
                                         image: { type: :string, nullable: true },
                                         gender: { type: :string, nullable: true },
                                         birthdate: { type: :date, nullable: true }, } }
                 }

          let(:user_register) { params_user }
          let(:order_token) {
            current_order_without_user.save
            current_order_without_user.token
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(current_order_without_user.user_id.nil?).to eq(true)
            expect(current_order_without_user.reload.user_id.nil?).to eq(false)
          end
        end

        response 401, 'error se validan datos!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string },
                   user: { type: :object,
                           properties: { id: { type: :integer, nullable: true },
                                         email: { type: :string },
                                         name: { type: :string },
                                         rut: { type: :string } } }
                 }

          let(:user_register) {
            params = params_user
            params[:user][:password_confirmation] = 'other'
            params
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
          end

          let(:user_register) {
            params = params_user
            params[:user][:name] = ''
            params
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
          end

          let(:user_register) {
            params = params_user
            params[:user][:email] = ''
            params
          }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
          end

          let(:user_register) {
            params = params_user
            params[:user][:password] = ''
            params
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
