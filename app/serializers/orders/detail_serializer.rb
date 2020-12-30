#
#  id               :bigint           not null, primary key
#  completed_at     :datetime
#  delivery_state   :string
#  number_ticket    :string
#  payment_state    :string
#  payment_total    :float            default(0.0)
#  shipment_total   :float            default(0.0)
#  state            :string
#  tax_total        :float            default(0.0)
#  token            :string
#  user_data        :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  address_id       :integer
#  user_id          :integer
#
class Orders::DetailSerializer < ActiveModel::Serializer
  attributes :id,
             :delivery_state,
             :number_ticket,
             :payment_state,
             :token,
             :payment_total,
             :created_at

  attribute :promotion_total
  attribute :shipment
  attribute :items_qty
  attribute :receive
  attribute :address
  attribute :products

  def shipment
    shipment = object.shipment
    return {} unless shipment.present?

    shipment_method = shipment.shipment_method

    {
      value: shipment.value,
      state: shipment.state,
      method_name: shipment_method.name,
      method_type: shipment_method.shipment_type
    }
  end

  def receive
    object.user_data
  end

  def items_qty
    object.order_items.map(&:item_qty).sum
  end

  def products
    ActiveModelSerializers::SerializableResource.new(object.order_items,
                                                     each_serializer: ::Orders::ItemCarSerializer)
  end

  def address
    return {} unless obj_address.present?

    ::Orders::AddressSerializer.new(obj_address)
  end

  def promotion_total
    object.order_adjustments.where(adjustable_type: 'Promotion'.freeze).sum(&:value)
  end

  def obj_address
    @obj_address ||= object.address
  end
end
