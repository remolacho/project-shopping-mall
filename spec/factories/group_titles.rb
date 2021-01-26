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
FactoryBot.define do
  factory :group_title do
    name { FFaker::Book.title }

    before(:create) do |title|
      title.slug = title.name.str_slug
    end
  end
end
