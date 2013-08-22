class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url and return
  end

protected

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_current_membership
    unless current_user && current_user.membership_status == 'active'
      flash[:notice] = "You must have a current Eastern League membership to access this page."
      redirect_to root_url
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
      return false
    end
  end

end
