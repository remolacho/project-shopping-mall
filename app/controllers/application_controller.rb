class ApplicationController < ActionController::API
  include ManageException
  include ManageObjects

  before_action :authorized_app
  before_action :authenticate_user!

  private

  def expired_redis
    eval(ENV['TIMEOUT_REDIS'])
  rescue StandardError
    1.day
  end
end
