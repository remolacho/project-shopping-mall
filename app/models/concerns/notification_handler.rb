module NotificationHandler
  extend ActiveSupport::Concern
  included do
    has_many :notifications, as: :target, dependent: :destroy

    def notify(options = {})
      notifications.create(options)
    end

    def notify_segments(segments = [])
      notifications.where(segment_type: segments)
    end

  end

end
