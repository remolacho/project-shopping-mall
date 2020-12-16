require 'swagger_helper'

RSpec.describe V1::Categories::ChildrenController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de categorias hijas' do
    path "/v1/category/{category_id}/children" do
      get 'Lista de categorias hijas' do
        tags 'Zofri categories'
        description "retorna la lista de categorias hijas"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :category_id, in: :path, required: true, type: :integer
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   categories: {
                       type: :array,
                       items: {
                           type: :object,
                           properties: {
                               id: { type: :integer },
                               name: { type: :string },
                               slug: { type: :string },
                               products_count: { type: :integer },
                               is_visible: { type: :boolean }
                           }
                       }
                   }
                 }

          let(:category_id) {
            products_category_child
            products_category_child_depth_3
            root_category.id
          }

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('categories').size.zero?).to eq(false)
          end
        end

        response 404, 'Error data no encontrada' do
          schema type: :object,
                 properties: {
                     success: {type: :boolean, default: false},
                     message: {type: :string}
                 }

          let(:category_id) { 9999 }
          run_test!
        end
      end
    end
  end
end
