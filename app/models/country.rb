# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_countries_on_code  (code)
#
class Country < ApplicationRecord
  has_many :regions
  has_many :companies
end
