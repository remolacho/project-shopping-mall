require 'swagger_helper'

RSpec.describe V1::Products::Collections::ListController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de productos en base a una colección' do
    path '/v1/products/collections/{collection_slug}' do
      get 'Lista de productos por colección' do
        tags 'Zofri Colecciones'
        description "Retorna una lista de productos en base a una colección se envia en el path el slug"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :collection_slug, in: :path
        parameter name: :category_id, in: :query, required: false, type: :string
        parameter name: :brand_ids, in: :query, required: false, type: :string
        parameter name: :prices, in: :query, required: false, type: :string
        parameter name: :order_by, in: :query, required: false, type: :string
        parameter name: :rating, in: :query, required: false, type: :integer
        parameter name: :page, in: :query, required: false, type: :integer

        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   collection: {
                     type: :object,
                     properties: {
                       id: { type: :integer, default: 1 },
                       name: { type: :string },
                       slug:{ type: :string },
                       image_url: { type: :string, nullable: true },
                       per_page: { type: :integer, default: 12 },
                       total_pages: { type: :integer, default: 4 },
                       total_objects: { type: :integer, default: 40 },
                       current_page: { type: :integer, default: 1 },
                       products: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string },
                             slug: { type: :string },
                             category_name: { type: :string },
                             short_description: { type: :string },
                             price: { type: :number },
                             discount_price: { type: :number },
                             rating: { type: :number },
                             image_url: { type: :string, nullable: true },
                             brand_name: { type: :string },
                           }
                         }
                       }
                   }
                 } }
          let(:collection_slug) { new_collection.slug }
          run_test!
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
