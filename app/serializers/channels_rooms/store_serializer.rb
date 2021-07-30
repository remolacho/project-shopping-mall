# frozen_string_literal: true

module ChannelsRooms
  class StoreSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end

