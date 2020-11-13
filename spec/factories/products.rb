# == Schema Information
#
# Table name: products
#
#  id                             :bigint           not null, primary key
#  deleted_at                     :datetime
#  hide_from_results              :boolean          default(FALSE)
#  name_translations              :hstore
#  rating                         :float            default(0.0)
#  short_description_translations :hstore
#  slug                           :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  brand_id                       :integer
#  category_id                    :integer
#  group_products_store_id        :integer
#  store_id                       :integer
#
# Indexes
#
#  index_products_on_brand_id     (brand_id)
#  index_products_on_category_id  (category_id)
#  index_products_on_deleted_at   (deleted_at)
#  index_products_on_store_id     (store_id)
#

FactoryBot.define do
  factory :product do
    name = FFaker::Book.title
    name { name }
    short_description { FFaker::Book.title }
    slug { name.str_slug }
    brand { brand }
    category { category }
    store { store }
    rating { rating }
  end

  trait :with_image do
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/avatar.png', 'image/png') }
  end
end
