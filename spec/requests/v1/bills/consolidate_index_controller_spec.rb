require 'swagger_helper'

RSpec.describe V1::Bills::ConsolidateController, type: :request do

  describe 'Retorna la info solicitada' do
    path "/v1/bills/consolidate/list/{ticket}" do
      get 'Retorna la info Solicitada' do
        tags 'Zofri Bills'
        description "Retorna la info Solicitada"
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: :ticket, in: :path

        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   id: { type: :string },
                   createdAt: { type: :string },
                   name: { type: :string },
                   data: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         rut: { type: :string },
                         store: { type: :string },
                         module: { type: :string },
                         saleDate: { type: :string },
                         price: { type: :number },
                         quantity: { type: :integer },
                         totalSale: { type: :number },
                         categoryId: { type: :integer },
                         categoryName: { type: :string },
                         paymentMethod: { type: :string },
                         totalZofrishop: { type: :number },
                         sellerIncome: { type: :number },
                         percentageMp: { type: :number },
                         commissionMp: { type: :number }
                       }
                     }
                   }
                 }

          let(:'Authorization') { ENV['ACCESS_TOKEN'] }

          let(:ticket) {
            result = Bills::Requests::Create.new(data: {from: '2021-01-01', to: '2021-11-05'}).call
            result[:data][:entity][:ticket]
          }

          run_test!
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
