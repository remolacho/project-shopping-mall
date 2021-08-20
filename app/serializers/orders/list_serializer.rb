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
class Orders::ListSerializer < ActiveModel::Serializer
  attributes :id, :delivery_state, :number_ticket, :payment_state, :token, :updated_at
  attribute :items_qty
  attribute :products
  attribute :store_orders
  attribute :shipment_total

  def items_qty
    object.order_items.map(&:item_qty).sum
  end

  def products
    ActiveModelSerializers::SerializableResource.new(object.order_items,
                                                     each_serializer: ::Orders::ItemCarSerializer)
  end

  def store_orders
    ActiveModelSerializers::SerializableResource.new(object.store_orders,
                                                     each_serializer: ::Orders::StoreOrdersSerializer)
  end
end
