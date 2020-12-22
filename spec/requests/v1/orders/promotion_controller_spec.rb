require 'swagger_helper'

RSpec.describe V1::Orders::PromotionController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  include_context 'order_stuff'

  describe "Aplica un cupon de descuento a la orden" do
    path "/v1/orders/{order_token}/promotion/apply/{promo_code}" do
      get 'Aplica el cupon a la orden y crea un ajuste' do
        tags 'Zofri Orders'
        description '<p>Envia el cupon y valida si aplica o no para la orden activa</p>'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: 'Authorization', in: :header, required: false
        parameter name: :order_token, in: :path, required: true, type: :string
        parameter name: :promo_code, in: :path, required: true, type: :string

        response 200, 'success!!!' do
          schema type: :object,
                 properties: { success: { type: :boolean },
                               order: { type: :object,
                                        properties: {
                                            id: { type: :integer },
                                            token: { type: :string },
                                            number_ticket: { type: :string },
                                            payment_total: { type: :number },
                                            promotion_total: { type: :number },
                                            state: { type: :string },
                                            user_data: { type: :object,
                                                         properties: {
                                                             name: { type: :string },
                                                             last_name: { type: :string },
                                                             email: { type: :string },
                                                             phone: { type: :string }
                                                         }
                                            },
                                            address: {
                                                type: :object,
                                                properties: {
                                                    street_number: {type: :string, nullable: true },
                                                    street: {type: :string, nullable: true },
                                                    condominium: {type: :string, nullable: true },
                                                    apartment_number: {type: :string, nullable: true },
                                                    comment: {type: :string, nullable: true },
                                                }
                                            },
                                            commune: {
                                                type: :object,
                                                properties: {
                                                    id: {type: :integer, nullable: true },
                                                    name: {type: :string, nullable: true }
                                                }
                                            },
                                            order_items: {
                                                type: :array,
                                                items: {
                                                    type: :object,
                                                    properties: {
                                                        id: { type: :integer },
                                                        product_variant_id: { type: :integer },
                                                        name: { type: :string },
                                                        weight: { type: :number },
                                                        height: { type: :number },
                                                        width: { type: :number },
                                                        length: { type: :number },
                                                        image_url: { type: :string, nullable: true },
                                                        unit_value: { type: :number},
                                                        item_qty: { type: :integer },
                                                        total: { type: :number },
                                                    }
                                                }
                                            }
                                        }
                               }
                 }

          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          let(:promo_code) { FactoryBot.create(:promotion, :amount_plain).promo_code }
          run_test!
        end

        response 404, 'not found!!!' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }


          let(:order_token) {
            current_order.save
            list_order_item
            current_order.token
          }

          let(:promo_code) { 'error-code' }

          run_test!
        end

      end
    end
  end
end
