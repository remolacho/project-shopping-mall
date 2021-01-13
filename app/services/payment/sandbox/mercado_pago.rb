class Payment::Sandbox::MercadoPago
  attr_accessor :payment, :external_reference

  def initialize(payment:, external_reference:)
    @payment = payment
    @external_reference = external_reference
  end

  def perform
    payments || {status: 'other', external_reference: external_reference}
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
    {status: 'approved', external_reference: external_reference}
  end

  def get_rejected
    {status: 'rejected', external_reference: external_reference}
  end

  def get_in_process
    {status: 'in_process', external_reference: external_reference}
  end

  def get_cancelled
    {status: 'cancelled', external_reference: external_reference}
  end

  def get_in_refunded
    {status: 'refunded', external_reference: external_reference}
  end
end
