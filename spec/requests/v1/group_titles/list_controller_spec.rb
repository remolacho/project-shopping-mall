require 'swagger_helper'

RSpec.describe V1::GroupTitles::CategoriesController, type: :request do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe 'Retorna una lista de Titulos segun la seccion enviada' do
    path '/v1/groupTitles/{section}' do
      get 'Lista de titulos por seccion' do
        tags 'Zofri titulos'
        description "retorna la lista de titulos por seccion (rating, discount, recents) se envia en el path"
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true
        parameter name: :section, in: :path

        response 200, 'success!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   section: { type: :string },
                   titles: { type: :array,
                             items: {
                               type: :object,
                               properties: {
                                 id: { type: :integer },
                                 name: { type: :string },
                                 slug: { type: :string },
                                 icon_url: { type: :string, nullable: true },
                                 image_url: { type: :string, nullable: true },
                               }
                             } }
                 }

          let(:section) { 'discount' }
          run_test!
        end

        response 403, 'Secret api error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:section) { 'discount' }
          let(:'secret-api') { 'error secret' }
          run_test!
        end
      end
    end
  end
end
