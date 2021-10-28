# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  data         :text
#  event_type   :string           default("info")
#  read         :boolean          default(FALSE), not null
#  segment_type :string           default("default")
#  sent_at      :datetime
#  target_type  :string
#  token        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  target_id    :bigint
#
# Indexes
#
#  index_notifications_on_read                       (read)
#  index_notifications_on_target_type_and_target_id  (target_type,target_id)
#
class Notification < ApplicationRecord
  serialize :data, Hash

  SELLER_STOCK = 'seller_stock_notification'.freeze
  SELLER = 'seller_notification'.freeze
  WARNING = 'warning'.freeze
  SUCCESS = 'success'.freeze

  belongs_to :target, polymorphic: true

  scope :new_first, -> { order(sent_at: :desc) }
  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  #Usage: Notification.for_group(users, attrs: { data: {title: 'titulo', content: 'contenido'}, sent_at: "2020-10-23 14:01:40"})
  def self.for_group(group, attrs: {})
    return if group.nil?
    group.map do |target|
      Notification.create(attrs.merge(target: target))
    end
  end

  def mark_as_read!
    update(read: true)
  end

  def self.mark_as_read!
    update_all(read: true)
  end

  def read?
    read
  end

  def unread?
    !read
  end

  def self.generate_token
    Digest::MD5.hexdigest("Zofr12020Et1n3R#{SecureRandom.uuid}-#{Time.now.strftime('%d%m%Y%H%M%S')}")
  end
end
