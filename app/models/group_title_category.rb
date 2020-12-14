# == Schema Information
#
# Table name: group_title_categories
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint           not null
#  group_title_id :bigint           not null
#
# Indexes
#
#  index_group_title_categories_on_category_id     (category_id)
#  index_group_title_categories_on_group_title_id  (group_title_id)
#
class GroupTitleCategory < ApplicationRecord
  belongs_to :group_title
  belongs_to :category
end
