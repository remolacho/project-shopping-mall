require 'swagger_helper'

RSpec.describe V1::Orders::ProductsController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Lista de productos a evaluar" do
    path "/v1/orders/{order_token}/products" do
      get 'listado de productos a evaluar' do
        tags 'Zofri Orders'
        description '<p>Retorna los productos que tienes en la orden de compra y que no esten evaluados</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :order_token, in: :path, required: true, type: :string
        response 200, 'success list!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   products: { type: :array,
                               items: {
                                 type: :object,
                                 properties: {
                                   id: { type: :integer },
                                   name: { type: :string },
                                   price: { type: :number },
                                   image_url: { type: :string, nullable: true },
                                   order_item_id: {  type: :integer },
                                   order_token: { type: :string },
                                   category_name: { type: :string },
                                   brand_name: { type: :string },
                                 }
                               } }
                 }

          let(:order_token) {
            list_order_item
            current_order.update(state: Order::IS_COMPLETED)
            current_order.token
          }

          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:order_token) { current_order.token }
          let(:'secret-api') { 'error secret' }
          run_test!
        end

        response 404, 'Order token error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:order_token) { current_order.token }
          run_test!
        end
      end
    end
  end
end
