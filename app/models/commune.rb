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
class Commune < ApplicationRecord
	belongs_to :region
	has_many :addresses
end
