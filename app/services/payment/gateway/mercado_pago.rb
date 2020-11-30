# frozen_string_literal: true

class Payment::Gateway::MercadoPago
  attr_accessor :attributes, :response

  def initialize(attributes:)
    @attributes = attributes
    @response = find_payment
  end

  def perform
    return struct('error_response_type', nil) unless attributes[:type].eql?('payment')
    return struct('error_response', nil) unless response.present?
    return struct('error_external_reference', nil) unless external_reference.present?

    struct(response[:status], current_order)
  rescue StandardError => e
    struct('error_exception', nil, e.to_s)
  end

  private

  def find_payment
    return sandbox_local_test if Rails.env.test?

    client_gateway.search_payment(payment_id)
  end

  def sandbox_local_test
    service = Payment::Sandbox::MercadoPago.new(payment: payment_id,
                                                number_ticket: attributes[:data][:number_ticket])
    service.perform
  end

  def client_gateway
    @client_gateway ||= Mercadopago::Sdk.new(ENV['CLIENT_ID_FREE_MARKET'],
                                             ENV['SECRET_FREE_MARKET'],
                                             is_sandbox?)
  end

  def is_sandbox?
    Rails.env.development?
  end

  def current_order
    @current_order ||= Order.find_by!(number_ticket: external_reference)
  end

  def change_status_types
    %w[authorized in_process].freeze
  end

  def skip_status_types
    %w[pending in_mediation charged_back].freeze
  end

  def errors_types
    %w[error_external_reference error_response error_exception error_response_type].freeze
  end

  def external_reference
    response[:external_reference]
  end

  def payment_id
    attributes[:data][:id]
  end

  def struct(status, order, message=nil)
    Struct.new(:order,
               :status,
               :change_status_types,
               :skip_status_types,
               :number_ticket,
               :payment_id,
               :errors_types,
               :message,
               :response).new(order,
                              status,
                              change_status_types,
                              skip_status_types,
                              external_reference,
                              payment_id,
                              errors_types,
                              message || status,
                              response)
  end
end
