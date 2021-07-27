# == Schema Information
#
# Table name: channels_rooms
#
#  id             :bigint           not null, primary key
#  active         :boolean          default(TRUE)
#  archived       :boolean          default(FALSE)
#  token          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  store_id       :bigint           not null
#  store_order_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_channels_rooms_on_store_id        (store_id)
#  index_channels_rooms_on_store_order_id  (store_order_id)
#  index_channels_rooms_on_token           (token) UNIQUE
#  index_channels_rooms_on_user_id         (user_id)
#
class ChannelsRoom < ApplicationRecord
  belongs_to :user
  belongs_to :store
  belongs_to :store_order

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::MD5.hexdigest("Zofr12020Et1n3R#{user_id}-#{store_order_id}-#{store_id}-#{alternative}")
  end

  def alternative
    (Time.now.to_f * 1000.0).to_i
  end
end
