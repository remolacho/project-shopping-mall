# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  name       :string
#  slug       :string
#  start_date :datetime
#  status     :string           default("inactive")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :collection do
    name { FFaker::Book.title }
    slug { FFaker::Book.title.str_slug }
    start_date { Time.now - 2.days }
    end_date { Time.now + 2.days }
    status { Collection::STATUS_ACTIVE }
  end
end
