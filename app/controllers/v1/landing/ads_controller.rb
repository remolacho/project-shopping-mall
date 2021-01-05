class V1::Landing::AdsController < ApplicationController
  skip_before_action :authenticate_user!

  # /v1/landing/ads
  def index
    @ads_small = Ad.where(active: :true, ad_type: :small).last(4)
    @ads_large = Ad.where(active: :true, ad_type: :large).last(2)
    render json: { success: true,
                   small: small_serializer,
                   large: large_serializer }, status: 200
  end

  def small_serializer
    ActiveModelSerializers::SerializableResource.new(@ads_small,
                                                     each_serializer: ::Landing::AdsSerializer)
                                                .as_json
  end

  def large_serializer
    ActiveModelSerializers::SerializableResource.new(@ads_large,
                                                     each_serializer: ::Landing::AdsSerializer)
                                                .as_json
  end

end