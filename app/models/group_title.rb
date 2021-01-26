# == Schema Information
#
# Table name: group_titles
#
#  id                :bigint           not null, primary key
#  burger            :boolean          default(FALSE)
#  home              :boolean          default(FALSE)
#  name_translations :hstore
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class GroupTitle < ApplicationRecord
  translates :name

  has_many :group_title_categories, dependent: :destroy
  has_many :categories, through: :group_title_categories

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..3.megabytes }

  has_one_attached :icon
  validates :icon, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/svg+xml'], size_range: 1..3.megabytes }

end
