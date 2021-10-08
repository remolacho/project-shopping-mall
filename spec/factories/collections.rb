# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  name       :string
#  slug       :string
#  start_date :datetime
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :collection do
    
  end
end
