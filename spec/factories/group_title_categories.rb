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
FactoryBot.define do
  factory :group_title_category do
    category { category }
    group_title { group_title }
  end
end
