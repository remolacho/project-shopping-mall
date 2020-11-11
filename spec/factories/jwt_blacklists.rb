# == Schema Information
#
# Table name: jwt_blacklists
#
#  id         :bigint           not null, primary key
#  exp        :datetime
#  jti        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_jwt_blacklists_on_jti  (jti)
#
FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2020-11-03 11:17:55" }
  end
end
