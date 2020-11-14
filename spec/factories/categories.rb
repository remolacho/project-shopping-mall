# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  code       :string
#  depth      :integer
#  name       :json
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_ancestry  (ancestry)
#

FactoryBot.define do
  factory :category do
    title = FFaker::Book.title
    name { {es: title} }
    slug { title.str_slug }
    code { FFaker::Book.title.str_slug }
    depth { depth }
  end
end
