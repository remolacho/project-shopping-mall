# == Schema Information
#
# Table name: store_download_files
#
#  id         :bigint           not null, primary key
#  type_file  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_store_download_files_on_store_id  (store_id)
#  index_store_download_files_on_user_id   (user_id)
#
FactoryBot.define do
  factory :store_download_file do
    
  end
end
