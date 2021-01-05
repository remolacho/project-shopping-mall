# == Schema Information
#
# Table name: slides
#
#  id              :bigint           not null, primary key
#  active          :boolean
#  name            :string
#  url_destination :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_slides_on_active  (active)
#
class Slide < ApplicationRecord

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/webp'] } 	

 end
