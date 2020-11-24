#
#  id               :bigint           not null, primary key
#  adjustment_total :float            default(0.0)
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
class Orders::ShoppingCarSerializer < ActiveModel::Serializer

  attributes :id, :order_token, :number_ticket, :state, :payment_total, :user_id
  attribute :order_items

  def order_token
    object.token
  end

  def order_items
    ActiveModelSerializers::SerializableResource.new(object.order_items,
                                                     each_serializer: ::Orders::ItemCarSerializer)
  end
end
