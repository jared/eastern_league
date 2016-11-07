class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to user_path(@user_session.record) and return
    else
      flash[:error] = "Login failed. Please check your email address and password, then try again."
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_path
  end

  private 

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end