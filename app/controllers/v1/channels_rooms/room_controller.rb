class V1::ChannelsRooms::RoomController < ApplicationController

  # GET /v1/channelRooms/:store_order_id/:created_by/create
  def create
    service = ChannelsRooms::Create.new(user: current_user,
                                        store: store_order.store,
                                        store_order: store_order,
                                        created_by: params[:created_by])

    render json: { success: true, room: service.perform }, status: 200
  end
end
