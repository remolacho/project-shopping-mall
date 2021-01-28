class V1::FrequentQuestionsController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /v1/faq
  def index
    render json: { success: true, faq: serializer } ,status: 200
  end

  def serializer
    ActiveModelSerializers::SerializableResource.new(FrequentQuestion.all, each_serializer: FrequentQuestionSerializer)
  end

end