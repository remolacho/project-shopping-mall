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
require 'rails_helper'

RSpec.describe Collection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
