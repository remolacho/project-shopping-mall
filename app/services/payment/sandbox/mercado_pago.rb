class Payment::Sandbox::MercadoPago
  attr_accessor :payment, :number_ticket

  def initialize(payment:, number_ticket:)
    @payment = payment
    @number_ticket = number_ticket
  end

  def perform
    payments || {status: 'other', external_reference: number_ticket}
  end

  private

  def payments
    hash_payment = {
      'approved' => get_approved,
      'rejected' => get_rejected,
      'cancelled' => get_cancelled,
      'in_process' => get_in_process,
      'refunded' => get_in_refunded
    }

    hash_payment[payment]
  end

  def get_approved
    {status: 'approved', external_reference: number_ticket}
  end

  def get_rejected
    {status: 'rejected', external_reference: number_ticket}
  end

  def get_in_process
    {status: 'in_process', external_reference: number_ticket}
  end

  def get_cancelled
    {status: 'cancelled', external_reference: number_ticket}
  end

  def get_in_refunded
    {status: 'refunded', external_reference: number_ticket}
  end
end
