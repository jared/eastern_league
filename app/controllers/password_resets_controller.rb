class PasswordResetsController < ApplicationController

  before_filter :require_no_user

  def new
  end

  def edit
    load_user_using_perishable_token
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you.  Please check your email."
      redirect_to root_url
    else
      flash[:notice] = "No user was found with that email address."
      render :action => :new
    end
  end

  def update
    load_user_using_perishable_token
    @user.password = params[:user][:password]
    if @user.save
      flash[:notice] = "Password successfully updated."
      UserSession.create(@user)
      redirect_to root_url
    else
      render :action => :edit
    end
  end


private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id], 48.hours)
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account.  If you are having issues, try copying and pasting the URL from your email into your browser or restarting the reset password process."
      redirect_to root_url and return
    end
  end

end
