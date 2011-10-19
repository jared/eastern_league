class MessagesController < ApplicationController

  before_filter :require_user
  
  def new
    @user = User.find(params[:user_id])
    authorize! :message, User.new, :message => "Only current Eastern League members can send messages."
    if @user.temporary_email?
      flash[:notice] = "Your message cannot be delivered, as this user has not provided an email address."
      redirect_to user_path(@user) and return
    end
  end
  
  def create
    @user = User.find(params[:user_id])
    authorize! :message, User.new, :message => "Only current Eastern League members can send messages."
    UserMailer.message(@user, current_user, params[:message]).deliver
    flash[:notice] = "Your message to #{@user.full_name} has been sent."
    redirect_to user_path(@user)
  end
  
end
