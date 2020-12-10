# == Schema Information
#
# Table name: products
#
#  id                             :bigint           not null, primary key
#  deleted_at                     :datetime
#  featured                       :boolean          default(FALSE)
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
    name { FFaker::Book.title }
    short_description { FFaker::Book.title }
    brand { brand }
    category { category }
    store { store }
    rating { rating }

    before(:create) do |product|
      product.slug = product.name.str_slug
    end
  end

  trait :with_image do
    image { Rack::Test::UploadedFile.new('spec/fixtures/files/avatar.png', 'image/png') }
  end

  trait :is_featured do
    featured { true }
  end
end
