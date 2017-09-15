class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def authenticate
    redirect_to login_url, alert: "Please login to view this page" unless current_user else true
  end

  def authorize
    redirect_to my_account_url, alert: "That page is only for Pro Users. Update your subscription or pay your charges!" unless authenticate && current_user.is_active? && !current_user.charge_failed?
  end

end
