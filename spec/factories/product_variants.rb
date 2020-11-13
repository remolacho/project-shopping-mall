# == Schema Information
#
# Table name: product_variants
#
#  id                             :bigint           not null, primary key
#  active                         :boolean
#  deleted_at                     :datetime
#  discount_value                 :float
#  height                         :float
#  internal_sku                   :string
#  is_master                      :boolean          default(FALSE)
#  length                         :float
#  name_translations              :hstore
#  price                          :float
#  short_description_translations :hstore
#  sku                            :string
#  weight                         :float
#  width                          :float
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  product_id                     :integer
#
# Indexes
#
#  index_product_variants_on_deleted_at    (deleted_at)
#  index_product_variants_on_internal_sku  (internal_sku)
#  index_product_variants_on_product_id    (product_id)
#  index_product_variants_on_sku           (sku)
#
FactoryBot.define do
  factory :product_variant do
    rng = RandomNameGenerator.new
    product { product }
    discount_value { rand(2) }
    height { rand(2) }
    sku { "SKU-#{rng.compose(3)}-#{rand(10000)}" }
    internal_sku { "SKU-INT-#{rng.compose(3)}-#{rand(10000)}" }
    length { rand(2) }
    name { product.name }
    price { price }
    short_description { product.short_description }
    weight { rand(2) }
    width { rand(2) }
    is_master { is_master }
  end
end
