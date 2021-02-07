require 'swagger_helper'

RSpec.describe V1::FrequentQuestionsController, type: :request do
  
  describe 'Retorna una lista con las preguntas frecuentes' do
    
    path '/v1/faq' do
      get 'Lista de preguntas frecuentes' do
        tags 'Zofri FAQ'
        description 'retorna una lista con las preguntas frecuentes'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'secret-api', in: :header, required: true

        response 200, 'success!!' do
          schema type: :object,
            properties: {
              success: { type: :boolean },
              faq: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    question: { type: :string },
                    answer: { type: :text }
                  }
                }
              }
            }
          
          let(:'secret-api') { ENV['SECRET_API'] }

          run_test! do |response|
            expect(response.status).to eq(200)
          end
        
        end

      end
    end

  end

end