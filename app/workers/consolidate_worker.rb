class ConsolidateWorker
  include Sidekiq::Worker
  sidekiq_options retry: true, queue: :default

  attr_accessor :ticket, :data, :path_folder, :file_path

  def perform(ticket, data)
    @data = data
    @ticket = ticket
    @path_folder = "tmp/billing-consolidate-#{bill_request.ticket}"
    @file_path = "#{path_folder}/consolidate.json"

    bill_request.in_process!

    return unless valid_request?

    process_completed
  rescue StandardError => e
    FileUtils.remove_entry_secure(path_folder, true)
    process_canceled(e.to_s)
  end

  private

  def valid_request?
    return true if billding.success

    process_canceled
  end

  def data_as_json
    @data_as_json ||= {
      id: bill_request.ticket,
      createdAt: bill_request.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
      name: BillsRequest::NAME_PROCESS,
      data: items
    }.to_json
  end

  def items
    billding.items.map do |item|
        {
          rut:            item[:rut],
          store:          item[:store_name],
          module:         item[:num_module],
          saleDate:       item[:ticket_date],
          price:          item[:unit_value],
          quantity:       item[:quantity],
          totalSale:      item[:total],
          categoryId:     item[:category_id],
          categoryName:   item[:category_name],
          paymentMethod:  item[:payment_method],
          totalZofrishop: item[:total_zofrishop],
          sellerIncome:   item[:seller_income],
          percentageMp:   item[:percentage_mp],
          commissionMp:   item[:commission_mp],
        }
    end
  end

  def bill_request
    @bill_request ||= BillsRequest.find_by(ticket: ticket)
  end

  def billding
    @billding ||= ::Bills::List.new(filter: data).call
  end

  def process_completed
    return process_canceled('no se creo el archivo') unless upload_file?

    Rails.cache.write "bills-consolidate-#{bill_request.ticket}", data_as_json, expires_in: expired

    FileUtils.remove_entry_secure(path_folder, true)
    bill_request.status = :completed
    bill_request.description = 'Se completa la carga con exito!!!'.freeze
    bill_request.checksum = create_checksum
    bill_request.save!
    true
  end

  def process_canceled(error = nil)
    bill_request.status = :canceled
    bill_request.description = error || billding.message
    bill_request.save!
    false
  end

  def upload_file?
    upload_file_yml
  end

  def upload_file_yml
    FileUtils.mkdir_p(path_folder)
    File.open(file_path, "w"){ |o| o.write(data_as_json)  }
    bill_request.file.attach(Rack::Test::UploadedFile.new(file_path, 'application/json'))
    bill_request.reload
    bill_request.file.attached?
  end

  def create_checksum
    Digest::SHA1.hexdigest Marshal::dump(data_as_json)
  end

  def expired
    eval(ENV['TIMEOUT_FREE_STOCK'])
  rescue
    5.minutes
  end
end
