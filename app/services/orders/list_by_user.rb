class Orders::ListByUser

  attr_accessor :user

  def initialize(user:)
    @user = user
  end

  def perform
    raise ActiveRecord::RecordNotFound, "the user hasn't orders" unless user.orders.present?

    ActiveModelSerializers::SerializableResource.new(user.orders.where.not(delivery_state: "unstarted", state: "on_purchase"),
                                                     each_serializer: ::Orders::ListSerializer)
  end
end
