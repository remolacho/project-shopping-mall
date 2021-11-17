module Bills
  module Requests
    class List

      attr_accessor :bill_request, :data_as_json

      def initialize(bill_request:)
        @bill_request = bill_request
      end

      def call
        return results_cache if results_cache.present?

        results_binary
      rescue StandardError => e
        { success: false, message: e.to_s }
      end

      private

      def results_cache
        @results_cache ||= Rails.cache.read  "bills-consolidate-#{bill_request.ticket}"
      end

      def results_binary
        results = JSON.parse binary
        Rails.cache.write "bills-consolidate-#{bill_request.ticket}", results, expires_in: expired
        results
      end

      def binary
        Rails.env.test? ? {} : bill_request.file.download
      end

      def expired
        eval(ENV['TIMEOUT_FREE_STOCK'])
      rescue
        5.minutes
      end
    end
  end
end
