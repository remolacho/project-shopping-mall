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
	 belongs_to :region, optional: true
   has_many :addresses
   has_many :shipment_costs
end
