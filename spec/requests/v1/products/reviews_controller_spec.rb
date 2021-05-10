require 'swagger_helper'

RSpec.describe V1::Products::ReviewsController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe 'Retorna el monitoreo de calificaciones' do
    path "/v1/product/reviews/{product_id}" do
      get 'Retorna el monitoreo de calificaciones' do
        tags 'Zofri Productos'
        description '<p>Retorna el monitoreo de calificaciones, average, total y grupo por puntaje con su respectivo %</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :product_id, in: :path
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   reviews: { type: :object,
                              properties: {
                                average: { type: :number },
                                total_rating: { type: :number },
                                monitoring_rating: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      label: { type: :string },
                                      total: { type: :number },
                                      percentage: { type: :number }
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
