# == Schema Information
#
# Table name: frequent_questions
#
#  id         :bigint           not null, primary key
#  answer     :string
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe FrequentQuestion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
