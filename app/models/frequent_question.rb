# == Schema Information
#
# Table name: frequent_questions
#
#  id         :bigint           not null, primary key
#  answer     :text
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FrequentQuestion < ApplicationRecord
end
