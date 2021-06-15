module ChannelsRooms
  class Create
    attr_accessor :user, :store, :store_order, :created_by, :allowed_created

    def initialize(user:, store:, store_order:, created_by:)
      @store = store
      @user = user
      @store_order = store_order
      @created_by = created_by
      @allowed_created = %w[seller customer]
    end

    def perform
      raise ArgumentError, "Params error #{created_by}" unless allowed_created.include?(created_by)

      raise ActiveRecord::RecordNotFound, 'the order has not user' unless user_owner.present?

      room = store.channels_rooms.find_or_create_by(store_order_id: store_order.id,
                                                    user_id: user_owner.id,
                                                    active: true)

      room.update!(archived: false)

      ActiveModelSerializers::SerializableResource.new(room,
                                                       serializer: ::ChannelsRooms::RoomSerializer,
                                                       current_user: user,
                                                       store: store)
    end

    private

    def user_owner
      return user unless created_by.eql?('seller')

      store_order.user
    end
  end
end
