# == Schema Information
#
# Table name: option_types
#
#  id         :bigint           not null, primary key
#  name       :json
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
	 factory :option_type do
 		 name = FFaker::Book.title
     name { name }
     slug { name.str_slug }
 	end
end