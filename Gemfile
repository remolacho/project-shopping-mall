source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

#.
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
  gem 'database_cleaner'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'rswag'
gem 'pry', '~> 0.12.2'
gem 'figaro'
gem 'active_model_serializers'
gem 'haikunator'
gem 'annotate', '~> 3.1', '>= 3.1.1'
gem 'httparty'
gem 'pagy'
gem 'pager_api'
gem "algoliasearch-rails"
gem "hstore_translate"
gem "roo", "~> 2.8.0"
gem 'devise'
gem 'devise-jwt'
gem 'acts_as_paranoid', '~> 0.7.0' # Soft delete
gem 'ancestry'
gem 'rolify'
gem 'activestorage-validator'
gem 'kaminari'
gem 'random_name_generator', '~> 1.2', '>= 1.2.1'
gem 'jwt'
gem 'mercadopago-sdk'
#AWS bucket
gem "aws-sdk-s3"

gem 'sidekiq'
gem 'redis'
gem 'hiredis'
gem 'whenever'

gem "rails-settings-manager"

gem 'wicked_pdf'
# we need the new binary here, so that we can be OS independent
gem 'wkhtmltopdf-binary'
