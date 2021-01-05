# == Schema Information
#
# Table name: ads
#
#  id              :bigint           not null, primary key
#  active          :boolean
#  ad_type         :integer
#  name            :string
#  url_destination :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_ads_on_active   (active)
#  index_ads_on_ad_type  (ad_type)
#
class Ad < ApplicationRecord

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/webp'] } 	

  enum ad_type: [ :small, :large ]

 end
