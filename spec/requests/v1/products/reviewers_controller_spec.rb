require 'swagger_helper'

RSpec.describe V1::Products::ReviewersController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe 'Retorna el monitoreo de calificaciones' do
    path "/v1/product/reviewers/{product_id}" do
      get 'Retorna la lista de personas que califican' do
        tags 'Zofri Productos'
        description '<p>Retorna la lista de personas que califican ordenado de mayor a menor, puede ordenar por desc, asc
y el num_page</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :product_id, in: :path
        parameter name: :num_page, in: :query, required: false
        parameter name: :sort, in: :query, required: false
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   reviewers: { type: :object,
                                properties: {
                                  per_page: { type: :number },
                                  total_pages: { type: :number },
                                  total_objects: { type: :number },
                                  current_page: { type: :number},
                                  comments: {
                                    type: :array,
                                    items: {
                                      type: :object,
                                      properties: {
                                        comment: { type: :string },
                                        score: { type: :number },
                                        full_name: { type: :string },
                                        image_url: { type: :string, nullable: true },
                                      }
                                    }
                                  }
                                } }
                 }

          let(:product_id) { ProductVariant.find(list_order_item.first.product_variant_id).product_id }

          run_test!
        end

        response 404, 'error not found!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:product_id) { 9999 }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'secret-api') { 'error secret' }
          let(:product_id) { ProductVariant.find(list_order_item.first.product_variant_id).product_id }
          run_test!
        end
      end
    end
  end
end
