namespace :load_group_titles_hierarchy do
  desc "TODO"
  task run: :environment do
    results = Rails.cache.read "all-title-children-categories"
    unless results.present?
      results = ::GroupTitles::Categories.new.perform
      Rails.cache.write "all-title-children-categories", results, expires_in: 1.day
    end
  end
end

def expired_redis
  eval(ENV['TIMEOUT_REDIS'])
rescue StandardError
  1.day
end
