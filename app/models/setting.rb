# == Schema Information
#
# Table name: settings
#
#  id            :bigint           not null, primary key
#  base_obj_type :string
#  key           :string           not null
#  value         :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  base_obj_id   :integer
#
# Indexes
#
#  index_settings_on_base_obj_id    (base_obj_id) UNIQUE
#  index_settings_on_base_obj_type  (base_obj_type) UNIQUE
#  index_settings_on_key            (key) UNIQUE
#
require "settings-manager"

class Setting < SettingsManager::Base
  allowed_settings_keys []
  default_settings_config Rails.root.join("config/default_settings.yml")
end
