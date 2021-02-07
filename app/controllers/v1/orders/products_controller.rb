# frozen_string_literal: true

module V1
  module Orders
    class ProductsController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /v1/orders/:order_token/products
      def index
        render json: { success: true, products: serializer }, status: 200
      end

      def serializer
        service = ::Products::ListToReview.new(order: order_completed)
        ActiveModelSerializers::SerializableResource.new(service.perform,
                                                         each_serializer: ::Orders::ProductsSerializer,
                                                         order_token: order_completed.token)
      end
    end
  end
end
