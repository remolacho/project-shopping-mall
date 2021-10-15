require 'swagger_helper'

RSpec.describe V1::Products::Collections::BrandsController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de marcas en base a una colección' do
    path '/v1/products/collections/brands/{collection_slug}' do
      get 'Lista las marcas por colección' do
        tags 'Zofri Colecciones'
        description "Retorna una lista de marcas en base a una colección se envia en el path el slug"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :collection_slug, in: :path
        parameter name: :category_id, in: :query, required: false, type: :string

        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   brands: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         name: { type: :string },
                         slug: { type: :string },
                         products_count: { type: :integer }
                       }
                     }
                   } }

          let(:collection_slug) {
            collection_products
            new_collection.slug
          }

          let(:category_id) { root_category.id }

          run_test! do |response|
            body = JSON.parse response.body
            expect(body['success']).to eq(true)
            expect(body['brands'].empty?).to eq(false)
            expect(response.status).to eq(200)
          end

        end

        response 404, 'Error data no encontrada' do
          schema type: :object,
                 properties: {
                   success: {type: :boolean, default: false},
                   message: {type: :string}
                 }

          let(:collection_slug) { 'test-error' }
          run_test!
        end

      end
    end
  end
end
