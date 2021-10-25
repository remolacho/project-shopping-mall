require 'swagger_helper'

RSpec.describe V1::Products::Collections::PriceRangeController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de precios por rango en una coleccion' do
    path "/v1/products/collections/price_range/{collection_slug}" do
      get 'Devuelve la lista de precios' do
        tags 'Zofri Colecciones'
        description '<p>Retorna una lista de precios basada en segmentos ejemplo: ["1000"-"2000", "2200"-"4000"]</p>'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :collection_slug, in: :path, required: true, type: :string
        parameter name: :category_id, in: :query, required: false, type: :integer
        produces 'application/json'
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean},
                   ranges: { type: :array, items: {type: :string} }
                 }

          let(:collection_slug) {
            collection_products
            new_collection.slug
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

          let(:collection_slug) { new_collection.slug }
          let(:category_id) { root_category.id }
          let(:'secret-api') { 'error secret' }

          run_test!
        end

        response 404, 'Error not found!!!' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:collection_slug) { new_collection.id }
          let(:category_id) { root_category.id }

          run_test!
        end
      end
    end
  end
end
