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
    name { {es: FFaker::Book.title.str_slug} }
    depth { depth }

    before(:create) do |category|
      category.slug = category.name['es'].str_slug
      category.code = category.name['es'].str_slug
    end
  end
end
