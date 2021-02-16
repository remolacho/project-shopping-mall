require 'swagger_helper'

RSpec.describe Users::WishlistController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'
  
  describe 'Retorna data del wishlist' do
    
    path '/users/wishlist' do
      get 'Devuelve una lista de productos deseados del usuario' do
        tags 'Zofri Users'
        description 'retorna una lista con los productos deseados de un usuario'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header, required: true

        response 200, 'success!!' do
          schema type: :object,
            properties: {
              success: { type: :boolean },
              wishlist: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    rating: {type: :float },
                    image_url: { type: :string },
                    name: { type: :string },
                    short_description: { type: :string },
                    category_name: { type: :string },
                    price: { type: :number },
                    discount_price: { type: :number },
                    brand_name: { type: :string },
                    store_name: { type: :string },
                    is_master: { type: :boolean },
                    variant_active: { type: :boolean },
                    featured: { type: :boolean }
                  }
                }
              }
            }

          let(:'Authorization') {auth_bearer(current_user, {})}
          let(:'secret-api') { ENV['SECRET_API'] }

          run_test! do |response|
            expect(response.status).to eq(200)
          end
        end

      end
    end

    path '/users/wishlist/addItem' do
      post 'Agrega un producto a la lista de deseos' do
        tags 'Zofri Users'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :product_data, in: :body, schema: {
          type: :object,
          properties: {
            product: {
              type: :object,
              properties: {
                id: { type: :integer }
              }
            }
          }
        }

        response 201, 'Success!!' do
          schema type: :object,
            properties: {
              success: { type: :boolean },
              message: { type: :string },
            }

          let(:'Authorization') {auth_bearer(current_user, {})}
          let(:'secret-api') { ENV['SECRET_API'] }
          let(:product_data) { { product: { id: products_category.last.id } }}

          run_test! do |response|
            expect(response.status).to eq(201)
          end
        end

      end
    end

    path '/users/wishlist/{product_id}' do
      delete 'Retira un producto de la lista de deseos' do
        tags 'Zofri Users'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header, required: true
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :product_id, in: :path, required: true, type: :integer

        response 200, 'success!!' do
          schema type: :object,
            properties: {
              success: { type: :boolean },
              message: { type: :string },
            }
          
          let(:'Authorization') {auth_bearer(current_user, {})}
          let(:'secret-api') { ENV['SECRET_API'] }
          let(:product_id) { wishlist_product.id }

          run_test! do |response|
            expect(response.status).to eq(200)
          end
        end

      end
    end

  end

end