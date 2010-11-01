class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  layout 'default'

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
end
