# frozen_string_literal: true

module ChannelsRooms
  class RoomSerializer < ActiveModel::Serializer
    attributes :id, :user, :store, :store_order_id, :active, :token

    def user
      ChannelsRooms::UserSerializer.new(instance_options[:current_user])
    end

    def store
      ChannelsRooms::StoreSerializer.new(instance_options[:store])
    end
  end
end
