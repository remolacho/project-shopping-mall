# == Schema Information
#
# Table name: store_modules
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  num_module :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint           not null
#
# Indexes
#
#  index_store_modules_on_store_id  (store_id)
#
FactoryBot.define do
  factory :store_module do
    
  end
end
