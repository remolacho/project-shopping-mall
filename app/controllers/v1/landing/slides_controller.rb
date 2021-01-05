class V1::Landing::SlidesController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/landing/ads
  def index
    @slides = Slide.where(active: :true).last(8)
    render json: { success: true,
                   slides: serializer}, status: 200
  end

  def serializer
    ActiveModelSerializers::SerializableResource.new(@slides,
                                                     each_serializer: ::Landing::SlidesSerializer)
                                                .as_json
  end

end