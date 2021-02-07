require 'swagger_helper'

RSpec.describe V1::Products::PriceRangeController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de precios por rango' do
    path "/v1/products/priceRange" do
      get 'Devuelve la lista de precios' do
        tags 'Zofri Productos'
        description '<p>Retorna una lista de precios basada en segmentos ejemplo: ["1000"-"2000", "2200"-"4000"]</p>'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :category_id, in: :query, required: true, type: :integer
        produces 'application/json'
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean},
                   ranges: {type: :array, items: {type: :string}}
                 }
          let(:category_id) { root_category.id }
          run_test!do |response|
            body = JSON.parse response.body
            expect(body.dig('ranges').present?).to eq(true)
          end
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }
          let(:category_id) { root_category.id  }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Error not found!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:category_id) { 99999  }
          run_test!
        end
      end
    end
  end
end
