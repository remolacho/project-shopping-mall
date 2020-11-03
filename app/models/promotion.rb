# == Schema Information
#
# Table name: promotions
#
#  id          :bigint           not null, primary key
#  ambit       :string
#  expires_at  :datetime
#  name        :json
#  promo_code  :string
#  rules       :string
#  starts_at   :datetime
#  usage_limit :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  store_id    :integer
#
# Indexes
#
#  index_promotions_on_store_id  (store_id)
#
class Promotion < ApplicationRecord
  belongs_to :store, optional: true

  LOCAL = 'local'.freeze
  GLOBAL = 'global'.freeze
end
