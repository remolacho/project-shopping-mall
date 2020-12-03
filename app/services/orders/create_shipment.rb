class Orders::CreateShipment
  attr_accessor :order, :data

  def initialize(order:, data:)
    @order = order
    @data = data
  end

  def perform
    raise ActiveRecord::RecordNotFound, 'the order state in not ON_PURCHASE' unless order.present?

    required_fields

    ActiveRecord::Base.transaction do
      create_address
      create_shipment
      update_order
      order.consolidate_payment_total
    end

    ::Orders::ShoppingCartSerializer.new(order, has_address: true)
  end

  private

  def required_fields
    return fields_in_site if in_site?

    fields_with_delivery
  end

  def fields_in_site
    raise ArgumentError, 'firstname es un campo obligatorio' unless data[:firstname].present?
    raise ArgumentError, 'lastname es un campo obligatorio' unless data[:lastname].present?
    raise ArgumentError, 'precio es un campo obligatorio' unless data[:delivery_price].present?
    raise ArgumentError, 'precio de envio debe ser numerico' unless data[:delivery_price].to_s.numeric?
    raise ArgumentError, 'precio es mayor a 0' unless data[:delivery_price].to_f.zero?
  end

  def fields_with_delivery
    raise ArgumentError, 'street es un campo obligatorio' unless data[:street].present?
    raise ArgumentError, 'precio es un campo obligatorio' unless data[:delivery_price].present?
    raise ArgumentError, 'precio de envio debe ser numerico' unless data[:delivery_price].to_s.numeric?

    fields = %i[apartment_number condominium street_number]
    fields.each { |field| return if data[field].present? }
    raise ArgumentError, "Debes enviar alguno de estos campos #{fields.join(',')}"
  end

  def create_shipment
    order_adjustments = order.order_adjustments

    if order_adjustments.present?
      Shipment.where(order_adjustment_id: order_adjustments.map(&:id),
                     shipment_method_state: Shipment::ACTIVE)
              .update_all(shipment_method_state: Shipment::INACTIVE, state: Shipment::CANCELLED)
    end

    shipment_method.shipments.create!(order_adjustment_id: order_adjustment.id,
                                      shipment_method_state: Shipment::ACTIVE,
                                      state: Shipment::PENDING)
  end

  def order_adjustment
    @order_adjustment ||= order.order_adjustments.create!(value: data[:delivery_price],
                                                          description: shipment_method.name)
  end

  def update_order
    order.address_id = address.id
    order.adjustment_total = order.order_adjustments.map{ |adjustment| adjustment.value.to_f }.sum
    order.delivery_state = Shipment::PENDING
    order.shipment_total = data[:delivery_price].to_f
    order.save!
  end

  def create_address
    address.commune_id = commune.id unless in_site?
    address.apartment_number = data[:apartment_number]
    address.condominium = data[:condominium]
    address.street = data[:street]
    address.street_number = data[:street_number]
    address.comment = data[:comment]
    address.latitude = data[:latitude]
    address.longitude = data[:longitude]
    address.firstname = data[:firstname]
    address.lastname = data[:lastname]
    address.save!
    address.reload
  end

  def address
    @address ||= order.address || Address.new
  end

  def commune
    @commune ||= Commune.find(data[:commune_id])
  end

  def shipment_method
    @shipment_method ||= ShipmentMethod.find(data[:shipment_id])
  end

  def in_site?
    shipment_method.shipment_type.eql?(ShipmentMethod::IN_SITE_TYPE)
  end
end
