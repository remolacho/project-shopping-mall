require 'swagger_helper'

RSpec.describe V1::Orders::CheckOrderController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Busca y edita la cantidad de items al carrito de compras" do
    path "/v1/orders/checkOrder/{order_token}" do
      get 'Validar Orden de compra' do
        tags 'Zofri Shopping cart'
        description '<p>Valida si permite el pago o no <b> NOTA: EL Authorization de la cabecera puede ir o no ir ya que es para asociar
la orden a un user o no</b></p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :path, required: true, type: :string
        response 200, 'success!!!' do
          schema type: :object,
                 properties: { success: { type: :boolean } }

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          run_test!
        end

        response 203, 'check no es valido' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   items_errors: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         product_variant_id: { type: :integer },
                         unit_value: { type: :number },
                         item_qty: { type: :integer },
                         error_type: { type: :string },
                         message: { type: :string }
                       }
                     }
                   }
                 }

          let(:order_token) {
            current_order.save
            item = list_order_item.last
            product_variant = item.product_variant
            quantity = product_variant.stock_movements.sum(&:quantity)
            FactoryBot.create(:stock_movement,
                              :inventory_out,
                              :with_order,
                              order: current_order_with_user,
                              product_variant: product_variant,
                              quantity: (quantity * -1))

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

          let(:order_token) { 'test error' }
          run_test!

          let(:order_token) {
            current_order.state = Order::IS_COMPLETED
            current_order.save
            current_order.token
          }

          run_test!
        end
      end
    end
  end
end
