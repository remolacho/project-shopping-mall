module Bills
  module Requests
    class Create

      attr_accessor :data, :result_to_json

      def initialize(data:)
        @data = data
        @result_to_json = { data: {} }
      end

      def call
        ActiveRecord::Base.transaction do

          result_to_json.merge!(status: 'success')
          result_to_json[:data].merge!({ entity: { ticket: request.ticket, dateOn: request.created_at } })

          ConsolidateWorker.perform_async(request.ticket, data)
        end

        result_to_json
      rescue StandardError => e
        result_to_json.merge!(status: 'error', message: e.to_s)
      end

      private

      def request
        @request ||= create_ticket
      end

      def create_ticket
        BillsRequest.create!(ticket: ticket, description: 'Se inicia la solicitud en segundo plano')
      end

      def ticket
        @ticket ||= Digest::MD5.hexdigest("Zofr12020Et1n3R#{Time.now.strftime('%d%m%Y%H%M%S')}-#{SecureRandom.uuid}")
      end
    end
  end
end
