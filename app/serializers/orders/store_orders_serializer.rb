
#
#  id               :bigint 
#  order_number     :string
#  store_id         :integer
#  store_name       :string

class Orders::StoreOrdersSerializer < ActiveModel::Serializer
  attributes :id, :store_id, :order_number, :store_name

  def store_name
    object.store.name
  end

  
end