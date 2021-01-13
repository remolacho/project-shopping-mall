# frozen_string_literal: true
require 'mercadopago'

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

    result = client_gateway.get_payment(payment_id)
    return unless result['response'].present?

    result['response'].deep_symbolize_keys
  end

  def sandbox_local_test
    service = Payment::Sandbox::MercadoPago.new(payment: payment_id,
                                                external_reference: attributes[:data][:external_reference])
    service.perform
  end

  def client_gateway
    @client_gateway ||= MercadoPago.new(ENV['ACCESS_TOKEN_PAYMENT'])
  end

  def current_order
    @current_order ||= Order.find_by!(token: external_reference)
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
               :order_token,
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
