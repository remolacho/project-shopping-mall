# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthdate              :date
#  complementary_info     :json
#  create_by              :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :string
#  jti                    :string
#  lastname               :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rut                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_gender                (gender)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { FFaker::Name.first_name }
    lastname { FFaker::Name.last_name }
    email { email }
    password { 'passwordtest123' }
    password_confirmation { 'passwordtest123'}
    rut { "#{FFaker::IdentificationESCL.rut}-#{20 + Random.rand(11)}" }
  end

  trait :is_admin do
    after(:create) do |user|
      user.add_role :admin
    end
  end
end
