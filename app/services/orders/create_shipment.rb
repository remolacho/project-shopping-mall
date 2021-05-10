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
    end

    ::Orders::ShoppingCartSerializer.new(order, has_address: true)
  end

  private

  def required_fields
    return fields_in_site if in_site?

    fields_with_delivery
  end

  def fields_in_site
    raise ArgumentError, 'Nombre es un campo obligatorio' unless data[:firstname].present?
    raise ArgumentError, 'Apellido es un campo obligatorio' unless data[:lastname].present?
    raise ArgumentError, 'precio es un campo obligatorio' unless data[:delivery_price].present?
    raise ArgumentError, 'precio de envio debe ser numerico' unless data[:delivery_price].to_s.numeric?
    raise ArgumentError, 'precio es mayor a 0' unless data[:delivery_price].to_f.zero?
  end

  def fields_with_delivery
    raise ArgumentError, 'Dirección es un campo obligatorio' unless data[:street].present?
    raise ArgumentError, 'precio es un campo obligatorio' unless data[:delivery_price].present?
    raise ArgumentError, 'precio de envio debe ser numerico' unless data[:delivery_price].to_s.numeric?
    raise ArgumentError, 'Debes seleccionar una comuna' unless data[:commune_id].present?

    fields = {
      :apartment_number=>'número de apartamento', 
      :condominium=>'condominio', 
      :street_number=>'número de calle'
    }
    fields.each { |field| return if data[field.first].present? }
    raise ArgumentError, "Debes enviar alguno de estos campos: #{fields.values.join(', ')}"
  end

  def create_shipment
    shipment = Shipment.find_or_create_by!(order_id: order.id)
    shipment.shipment_method_id = shipment_method.id
    shipment.value = shipment_cost
    shipment.carrier_id = shipment_carrier.id
    shipment.shipment_method_state = Shipment::ACTIVE
    shipment.state = Shipment::PENDING
    shipment.save!
  end

  def update_order
    order.address_id = address.id
    order.delivery_state = Order::PENDING_DELIVERY
    order.shipment_total = shipment_cost
    order.save!
    order.consolidate_payment_total
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

  def shipment_cost
    return @shipment_cost = 0 if in_site?
    total_weight ||= order.total_weight.ceil.clamp(0, 50)
    if total_weight <= 20 && commune.name == "Iquique" && total_sum_order_items <= 100000.0
      @shipment_cost = 2990
    else
      @shipment_cost ||= ShipmentCost.find_by(commune_id: commune.id, weight: total_weight).try(:cost) || ShipmentCost.where(commune_id: commune.id).maximum(:cost) || 3000
    end
  end

  def total_sum_order_items
    order.order_items.map { |order_item| (order_item.unit_value * order_item.item_qty).to_f }.sum
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

  def shipment_carrier
    total_weight ||= order.total_weight.ceil.clamp(0, 50)
    if total_weight <= 20 && commune.name == "Iquique" && total_sum_order_items <= 100000.0
      @shipment_carrier = Carrier.find_by(slug: "pedidos-ya")
    else
      shipment_cost = ShipmentCost.find_by(commune_id: commune.id, weight: total_weight) || ShipmentCost.where(commune_id: commune.id).first
      @shipment_carrier = Carrier.find(shipment_cost.id)
    end
  end

  def in_site?
    shipment_method.shipment_type.eql?(ShipmentMethod::IN_SITE_TYPE)
  end
end
