class Ad < ApplicationRecord

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/webp'] } 	

  enum ad_type: [ :small, :large ]

 end
