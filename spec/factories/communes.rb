# == Schema Information
#
# Table name: communes
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  region_id  :integer
#

FactoryBot.define do
	 factory :commune do
 		 name { FFaker::Book.title }
     region { region }
 	end
end
