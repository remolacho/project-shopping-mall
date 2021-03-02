# frozen_string_literal: true

module V1
  module GroupTitles
    class CategoriesController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /v1/groupTitles/categories
      def index
        results = Rails.cache.read "all-title-children-categories"

        if results.present?
          render json: { success: true, titles: results }, status: 200
          return
        end

        results = ::GroupTitles::Categories.new.perform
        Rails.cache.write "all-title-children-categories", results, expires_in: expired_redis
        render json: { success: true, titles: results }, status: 200
      end

      # GET /v1/groupTitles/categories/:title_id
      def show
        render json: { success: true,
                       title: ::Categories::GroupTitleSerializer.new(group_title) }, status: 200
      end
    end
  end
end
