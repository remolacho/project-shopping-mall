# == Schema Information
#
# Table name: products
#
#  id                             :bigint           not null, primary key
#  deleted_at                     :datetime
#  hide_from_results              :boolean          default(FALSE)
#  name_translations              :hstore
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
class Product < ApplicationRecord
  translates :name, :short_description

  acts_as_paranoid

  belongs_to :store
  belongs_to :brand, optional: true
  belongs_to :category
  belongs_to :group_products_store, optional: true

  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true

  has_one_attached :image
  validates :image, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..3.megabytes }

  has_rich_text :description

  after_save :update_repository

  validates_presence_of %i[name short_description store_id category_id brand_id],  message: "es un campo obligatorio"

  private

  # se hace de esta forma y no find or create by para evitar
  # la doble reindex en algolia
  def update_repository
    repository = RepositoryProduct.find_by(slug: self.slug, category_id: self.category_id, brand: self.brand.name)
    repository ||= RepositoryProduct.new(slug: self.slug,
                                         category_id: self.category_id,
                                         brand: self.brand.name,
                                         code: "ZOFRI#{Time.now.strftime('%S%d%m%Y%H%M')}",
                                         side_code: "ZOFRI")

    repository.name = self.name_translations
    repository.save!
  end
end
