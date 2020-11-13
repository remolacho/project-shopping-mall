class ApplicationController < ActionController::API
  include ManageException
  include ManageObjects

  before_action :authorized_app
  before_action :authenticate_user!

end
