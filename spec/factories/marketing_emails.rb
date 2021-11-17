# == Schema Information
#
# Table name: marketing_emails
#
#  id         :bigint           not null, primary key
#  email      :string
#  last_name  :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_marketing_emails_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :marketing_email do
    
  end
end
