class UsersController < ApplicationController

  before_filter :require_user, :except => [:show, :new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    authorize! :update, @user, :message => "You may only edit your own account."
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
    @user = User.find(params[:id])
    authorize! :update, @user, :message => "You may only edit your own account."
    
    @user.attributes = params[:user]
    if params[:remove_avatar]
      @user.competitor.avatar = nil
    end
    if @user.save
      flash[:notice] = "Update successful!"
      redirect_to user_path(@user)
    else
      flash[:error] = "Unable to save your changes.  See explanation below"
      render :action => :edit
    end
  end

end
