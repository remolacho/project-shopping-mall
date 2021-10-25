class HaveMessageMailer < ApplicationMailer

  def customer( channel_room: )
    @room = ChannelsRoom.find_by(token: channel_room)
    @email_to = @room.user.email 
    @subject = "Tienes un nuevo mensaje en tu compra #{@room.store_order.order.number_ticket}."
    mail(to: @email_to, subject: @subject)
  end

  def seller( channel_room: )
    @room = ChannelsRoom.find_by(token: channel_room)
    @email_to = @room.store.company.contact_email 
    @subject = "Tienes un nuevo mensaje en Zofrishop."
    mail(to: @email_to, subject: @subject)
  end 

end
