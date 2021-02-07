require 'swagger_helper'

RSpec.describe V1::Categories::ChildrenController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de categorias padres' do
    path "/v1/categories/parents" do
      get 'Lista de categorias padres' do
        tags 'Zofri categories'
        description "retorna la lista de categorias padres"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
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

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('categories').size.zero?).to eq(false)
            expect(body.dig('categories').all?{|cat| !cat['products_count'].zero?})
          end
        end
      end
    end
  end
end
