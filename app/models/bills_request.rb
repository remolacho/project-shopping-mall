# == Schema Information
#
# Table name: bills_requests
#
#  id          :bigint           not null, primary key
#  checksum    :string
#  description :string
#  status      :integer          default("unstated")
#  ticket      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_bills_requests_on_ticket  (ticket) UNIQUE
#
class BillsRequest < ApplicationRecord
  has_one_attached :file, dependent: :destroy_all

  NAME_PROCESS = 'VENTAS ZOFRISHOP'.freeze

  enum status: [:unstarted, :in_process, :completed, :canceled]

  def message
    messages[status.to_sym][:text]
  end

  def code
    messages[status.to_sym][:code]
  end

  def byte_size
    return 0 unless file.attached?

    file.byte_size
  end

  private

  def messages
    @messages ||= {
      unstarted:  {text: 'La consulta no ha comenzado', code: 0},
      in_process: {text: 'La consulta se esta procesando', code: 1},
      completed:  {text: 'La consulta finalizo con exito', code: 2},
      canceled:   {text: 'La consulta se cancelo', code: 3}
    }
  end
end
