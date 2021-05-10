# frozen_string_literal: true

module V1
  module GroupTitles
    class ListController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /v1/groupTitles/:section
      def index
        result = ::GroupTitles::List.new(section: section_allowed)
        render json: result.perform
      end
    end
  end
end
