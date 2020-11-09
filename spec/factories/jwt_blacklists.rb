FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2020-11-03 11:17:55" }
  end
end
