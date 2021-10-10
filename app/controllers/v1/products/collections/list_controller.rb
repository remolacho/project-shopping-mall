# frozen_string_literal: true
module V1
  module Products
    module Collections
      class ListController < ApplicationController
        skip_before_action :authenticate_user!

        # GET /v1/products/collections/:collection_slug
        def index
          service = ::Products::Collections::List.new(collection: collection, data: params)
          render json: service.perform
        end
      end
    end
  end
end
