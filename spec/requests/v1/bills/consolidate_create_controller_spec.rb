require 'swagger_helper'

RSpec.describe V1::Bills::ConsolidateController, type: :request do

  describe 'Crea la solicitud para que obtener la data facturada' do
    path "/v1/bills/consolidate" do
      post 'Lista la informacion para hacer seguimiento del proceso' do
        tags 'Zofri Bills'
        description "Crea la solicitud para que obtener la data facturada"
        produces 'application/json'
        consumes 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: :range_date, in: :body, schema: {
          type: :object,
          properties: {
            from: { type: :string },
            to: { type: :string }
          },
          required: [ 'from', 'to' ]
        }
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   status: { type: :string, default: 'success' },
                   data: {
                     type: :object,
                     properties: {
                       entity: {
                         type: :object,
                         properties: {
                           ticket: { type: :string },
                           dataOn: { type: :string }
                         }
                       }
                     }
                   }
                 }

          let(:'Authorization') { ENV['ACCESS_TOKEN'] }
          let(:range_date) { {from: '2021-01-01', to: '2021-11-05'} }

          run_test! do |response|
            body = JSON.parse response.body
            expect(body.dig('status').eql?('success')).to eq(true)
          end
        end

        response 422, 'Error Arguments' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:'Authorization') { ENV['ACCESS_TOKEN'] }
          let(:range_date) { {} }
          run_test!
        end

        response 403, 'Error Authorization' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:'Authorization') { 'Error' }
          let(:range_date) { {from: '2021-01-01', to: '2021-11-05'} }
          run_test!
        end
      end
    end
  end
end
