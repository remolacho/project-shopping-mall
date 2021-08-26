class V1::ChannelsRooms::RoomController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorized_app

  # GET /v1/channelRooms/:store_order_id/:created_by/create
  def create
    service = ChannelsRooms::Create.new(user: current_user,
                                        store: store_order.store,
                                        store_order: store_order,
                                        created_by: params[:created_by])

    render json: { success: true, room: service.perform }, status: 200
  end

  def notify_customer
    HaveMessageMailer.customer(channel_room: params[:token]).deliver_later
    render status: 200
  end

  def notify_seller
    room = ChannelsRoom.find_by(store_order_id: params[:token])
    HaveMessageMailer.seller(channel_room: room.token).deliver_later
    render status: 200
  end

end
