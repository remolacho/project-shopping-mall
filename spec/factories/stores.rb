# == Schema Information
#
# Table name: stores
#
#  id             :bigint           not null, primary key
#  active         :boolean
#  certifications :string
#  contact_phone  :string
#  facebook       :string
#  instagram      :string
#  mall_location  :string
#  name           :string
#  sheets_row     :integer
#  terms_accepted :boolean          default(FALSE)
#  twitter        :string
#  website        :string
#  what_we_do     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :integer
#  commune_id     :integer
#  company_id     :integer
#
# Indexes
#
#  index_stores_on_commune_id     (commune_id)
#  index_stores_on_mall_location  (mall_location)
#  index_stores_on_name           (name)
#
FactoryBot.define do
  factory :store do
    name { FFaker::Book.title }
    certifications { nil }
    facebook { "https://facebook/#{FFaker::Book.title.str_slug}" }
    instagram { "https://instagram/#{FFaker::Book.title.str_slug}" }
    sheets_row { nil }
    twitter { "https://twitter/#{FFaker::Book.title.str_slug}" }
    website { "https://website/#{FFaker::Book.title.str_slug}" }
    what_we_do { RandomNameGenerator.new.compose(150) }
    mall_location { "#{FFaker::Book.title}@#{company.name.str_slug}.com" }
    contact_phone { "#{rand(5)}#{rand(5)}#{rand(5)}-#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}" }
    category { category }
    commune { commune }
    company { company }
  end

  trait :is_active do
    active { true }
  end

  trait :is_inactive do
    active { false }
  end

end
