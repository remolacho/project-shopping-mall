class V1::Orders::PaymentController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorized_app

  # POST /v1/orders/payment
  def create
    service = Payment::Create.new(data: params).perform
    render json: service, status: service[:status]
  end

end
