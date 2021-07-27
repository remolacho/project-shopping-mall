# frozen_string_literal: true

module ChannelsRooms
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :lastname
  end
end
