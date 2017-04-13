class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  #def current_user
  #  @current_user  ||= User.find(session[:user_id]) if session[:user_id]
  #end

  def current_user
    @current_user ||= fetch_user(session[:user_id])
  end

  def fetch_user(id)
    User.find_by_id(id) || reset_session unless id.nil?
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
end
