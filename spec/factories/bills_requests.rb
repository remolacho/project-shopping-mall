# == Schema Information
#
# Table name: bills_requests
#
#  id          :bigint           not null, primary key
#  checksum    :string
#  description :string
#  status      :integer          default("unstarted")
#  ticket      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_bills_requests_on_ticket  (ticket) UNIQUE
#
FactoryBot.define do
  factory :bills_request do
    
  end
end
