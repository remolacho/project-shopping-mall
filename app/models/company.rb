# == Schema Information
#
# Table name: companies
#
#  id                         :bigint           not null, primary key
#  contact_email              :string
#  contact_phone              :string
#  fantasy_name               :string
#  legal_representative_email :string
#  legal_representative_name  :string
#  legal_representative_phone :string
#  legal_representative_rut   :string
#  name                       :string
#  rut                        :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  country_id                 :integer
#  user_id                    :integer
#
# Indexes
#
#  index_companies_on_country_id                (country_id)
#  index_companies_on_legal_representative_rut  (legal_representative_rut)
#  index_companies_on_rut                       (rut)
#
class Company < ApplicationRecord
	belongs_to :country
	belongs_to :user
	has_many :stores
end
