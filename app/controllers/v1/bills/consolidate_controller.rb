class V1::Bills::ConsolidateController < ApplicationController
  include ActiveStorage::SetCurrent

  skip_before_action :authorized_app
  skip_before_action :authenticate_user!
  before_action :authorized_zofri
  before_action :is_completed, only: [:index]

  # POST /v1/bills/consolidate
  def create
    service = Bills::Requests::Create.new(data: allowed_range)

    render json: service.call, content_type: 'application/json'
  end

  # GET /v1/bills/consolidate/:ticket
  def show
    service = Bills::Requests::Show.new(bill_request: bill_request)

    render json: service.call, content_type: 'application/json'
  end

  # GET /v1/bills/consolidate/list/:ticket
  def index
    service = Bills::Requests::List.new(bill_request: bill_request)

    render json: service.call, content_type: 'application/json'
  end

  private

  def allowed_range
    if params[:from].blank? || params[:to].blank?
      raise ArgumentError, 'Deben enviar un rango de fecha {from: YYYY-MM-DD, to: YYYY-MM-DD}'
    end

    { from: params[:from], to: params[:to] }
  end

  def bill_request
    @bill_request ||= BillsRequest.find_by!(ticket: params[:ticket])
  end

  def is_completed
    raise ActiveRecord::RecordNotFound, 'La solicitud no se ha completado' unless bill_request.completed?

    true
  end
end
