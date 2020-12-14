require 'swagger_helper'

RSpec.describe V1::GroupTitles::CategoriesController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'

  describe 'Retorna una lista de categorias agrupadas por cada titulo' do
    path '/v1/groupTitles/categories' do
      get 'Lista de titulos y sus categorias' do
        tags 'Zofri titulos'
        description "retorna la lista de titulos y sus categorias"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   titles: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         name: { type: :string },
                         slug: { type: :string },
                         categories: {
                           type: :array,
                           items: {
                             type: :object,
                             properties: {
                               id: { type: :integer },
                               name: { type: :string },
                               slug: { type: :string },
                             }
                           }
                         }
                       }
                     }
                   }
                 }

          let!(:titles) { group_titles }

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('titles').present?).to eq(true)
            expect(body.dig('titles').all? { |title| !title['categories'].size.zero? }).to eq(true)
          end
        end
      end
    end
  end

  describe 'Retorna una lista de categorias por el titulo enviado' do
    path '/v1/groupTitles/categories/{title_id}' do
      get 'Lista de categorias agrupadas por titulo' do
        tags 'Zofri titulos'
        description "retorna la lista de categorias agrupadas por titulo"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :title_id, in: :path, required: true
        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   title: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       slug: { type: :string },
                       categories: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             id: { type: :integer },
                             name: { type: :string },
                             slug: { type: :string },
                           }
                         }
                       }
                     }
                   }
                 }

          let!(:title_id) { group_titles.first.id }

          run_test! do |res|
            body = JSON.parse(res.body)
            expect(body.dig('title').present?).to eq(true)
            expect(body.dig('title', 'categories').present?).to eq(true)
          end
        end
      end
    end
  end
end
