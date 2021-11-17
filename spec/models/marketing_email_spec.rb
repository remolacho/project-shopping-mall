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
require 'rails_helper'

RSpec.describe MarketingEmail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
