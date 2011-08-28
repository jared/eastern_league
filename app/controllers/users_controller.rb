class UsersController < ApplicationController

  before_filter :require_user, :except => [:new, :create]

  def new
    @user = User.new
  end

  def edit
    if current_user.admin? || current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
    else
      flash[:error] = "You may only edit your own account."
      redirect_to edit_user_path(current_user)
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserSession.new(@user).save
      flash[:notice] = "You have successfully created an account"
      redirect_to root_url
    else
      flash[:error] = "Unable to create your account.  See explanation below"
      render :action => :new
    end
  end

  def update
    if current_user.admin? || current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
    else
      flash[:error] = "You may only edit your own account."
      redirect_to edit_user_path(current_user) and return
    end
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "Update successful!"
      redirect_to root_path
    else
      flash[:error] = "Unable to save your changes.  See explanation below"
      render :action => :edit
    end
  end

end
