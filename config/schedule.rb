# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

# Genera el cron para ser ejecutado
# whenever --update-crontab --set environment=development
# crontab -l listar
# crontab -r borrar
# sudo service cron restart reinicia el cron para aplicar los cambios

set :output, 'log/cron.log'  # Step 1

every 1.day, at: '01:00 am' do
  rake 'load_group_titles_hierarchy:run'
end

every 20.minutes do
  rake 'return_stock:run'
end

every 1.day, at: '02:00 am' do
  rake 'sellers_payment:run'
end
