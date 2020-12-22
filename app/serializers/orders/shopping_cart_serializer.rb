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
class Orders::ShoppingCartSerializer < ActiveModel::Serializer

  attributes :id,
             :order_token,
             :number_ticket,
             :state,
             :payment_total,
             :user_id,
             :user_data,
             :shipment_total

  attribute :promotion_total
  attribute :order_items
  attribute :address, if: :has_address?
  attribute :commune, if: :has_address?

  def order_token
    object.token
  end

  def order_items
    ActiveModelSerializers::SerializableResource.new(object.order_items,
                                                     each_serializer: ::Orders::ItemCarSerializer)
  end

  def address
    return {} unless obj_address.present?

    ::Orders::AddressSerializer.new(obj_address)
  end

  def commune
    return {} unless obj_commune.present?

    { id: obj_commune.id, name: obj_commune.name }
  end

  def obj_address
    @obj_address ||= object.address
  end

  def obj_commune
    return '' unless obj_address.present?

    @obj_commune ||= obj_address.commune
  end

  def promotion_total
    object.order_adjustments.where(adjustable_type: 'Promotion'.freeze).sum(&:value)
  end

  def has_address?
    instance_options[:has_address] == true
  end
end
