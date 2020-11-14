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
FactoryBot.define do
	 factory :company do
    contact_email { "#{FFaker::Name.first_name}.#{20 + Random.rand(11)}#{20 + Random.rand(11)}#{20 + Random.rand(11)}@etiner.com" }
    contact_phone { "#{rand(5)}#{rand(5)}#{rand(5)}-#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}" }
    fantasy_name { FFaker::Book.title }
    legal_representative_email { "#{FFaker::Name.first_name}.#{20 + Random.rand(11)}#{20 + Random.rand(11)}#{20 + Random.rand(11)}@etiner.com" }
    legal_representative_name { FFaker::Book.title }
    legal_representative_phone { "#{rand(5)}#{rand(5)}#{rand(5)}-#{rand(5)}#{rand(5)}#{rand(5)}#{rand(5)}" }
    legal_representative_rut { FFaker::IdentificationESCL.rut }
    name { FFaker::Book.title }
    rut  { FFaker::IdentificationESCL.rut }
    country { country }
    user { user }
 	end
end

