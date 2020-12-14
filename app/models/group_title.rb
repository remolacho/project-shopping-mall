# == Schema Information
#
# Table name: group_titles
#
#  id                :bigint           not null, primary key
#  name_translations :hstore
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class GroupTitle < ApplicationRecord
  translates :name

  has_many :group_title_categories, dependent: :destroy
  has_many :categories, through: :group_title_categories
end
