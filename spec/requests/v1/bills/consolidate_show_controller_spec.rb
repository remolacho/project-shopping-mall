require 'swagger_helper'

RSpec.describe V1::Bills::ConsolidateController, type: :request do

  describe 'Verifica el estatus de progreso que lleva la solicitud' do
    path "/v1/bills/consolidate/{ticket}" do
      get 'Retorna la info para ver el estado en que va la solicitud' do
        tags 'Zofri Bills'
        description "Verifica el estatus de progreso que lleva la solicitud"
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: :ticket, in: :path

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
                           name: { type: :string },
                           dataOn: { type: :string },
                           status: {
                             type: :object,
                             properties: {
                               code: { type: :integer },
                               name: { type: :string },
                             }
                           }
                         }
                       },
                       messages: {
                         type: :object,
                         properties: {
                           code: { type: :string },
                           text: { type: :string },
                           severity: { type: :string }
                         }
                       },
                       bytes:  { type: :integer },
                       checksum:  { type: :string },
                       mimeType: { type: :string }
                     }
                   }
                 }

          let(:'Authorization') { ENV['ACCESS_TOKEN'] }

          let(:ticket) {
            result = Bills::Requests::Create.new(data: {from: '2021-01-01', to: '2021-11-05'}).call
            result[:data][:entity][:ticket]
          }

          run_test! do |response|
            body = JSON.parse response.body
            expect(body.dig('status').eql?('success')).to eq(true)
          end
        end

        response 404, 'Error Arguments' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:'Authorization') { ENV['ACCESS_TOKEN'] }
          let(:ticket) { '55555555555555555555555555' }

          run_test!
        end

        response 403, 'Error ticket' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:'Authorization') { 'Error' }
          let(:ticket) { '55555555555555555555555555' }
          run_test!
        end
      end
    end
  end
end
