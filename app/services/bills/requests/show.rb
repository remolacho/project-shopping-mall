module Bills
  module Requests
    class Show

      attr_accessor :bill_request

      def initialize(bill_request:)
        @bill_request = bill_request
      end

      def call
        { status: 'success', data: body_message(bill_request.message).merge(body_entity) }
      rescue StandardError => e
        { status: 'error', data: body_message(e.to_s) }
      end

      private

      def body_message(text)
        {
          messages: {
            code: "ZOFRI-#{bill_request.id}",
            description: bill_request.description,
            text: text,
            severity: "I"
          }
        }
      end

      def body_entity
        {
          entity: {
            name: BillsRequest::NAME_PROCESS,
            dateOn: Time.current,
            status:  { code: bill_request.code, name: bill_request.status }
          }.merge(meta_data)
        }
      end

      def meta_data
        {
          bytes: bill_request.byte_size,
          checksum: bill_request.checksum,
          mimeType: 'JSON'.freeze
        }
      end
    end
  end
end
