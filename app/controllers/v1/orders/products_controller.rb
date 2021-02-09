# frozen_string_literal: true

module V1
  module Orders
    class ProductsController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /v1/orders/:order_token/products
      def index
        render json: { success: true, products: serializer }, status: 200
      end

      # POST /v1/orders/:order_token/products/review
      def review
        ::Products::CreateReview.new(order: order_completed,
                                     product: current_product,
                                     data: params[:review]).perform

        render json: { success: true, products: serializer }, status: 200
      end

      private

      def serializer
        service = ::Products::ListToReview.new(order: order_completed)
        ActiveModelSerializers::SerializableResource.new(service.perform,
                                                         each_serializer: ::Orders::ProductsSerializer,
                                                         order_token: order_completed.token)
      end

      def current_product
        order_completed.products.find(params[:review][:product_id])
      end
    end
  end
end
