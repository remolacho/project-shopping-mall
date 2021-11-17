# frozen_string_literal: true
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
  config.action_controller.perform_caching = true
  config.session_store :cache_store, key: ENV['APP_SESSION_KEY']

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :amazon

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.active_job.queue_adapter = :sidekiq
  config.active_storage.queues = Hash.new(:default)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: ENV['EMAIL_PROVIDER'],
      domain: ENV['EMAIL_DOMAIN'],
      port: 587,
      user_name: ENV['EMAIL_FROM'],
      password: ENV['EMAIL_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
  }
end
