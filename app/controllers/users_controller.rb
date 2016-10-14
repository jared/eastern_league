class UsersController < ApplicationController

  before_filter :require_user, :except => [:show, :new, :create]

  def index
    @users = User.all
    authorize! :manage, User.new, :message => "Only an administrator may view the list of users"
  end
  
  def search
    authorize! :search, User.new, :message => "Only current Eastern League members may use the search function."
    if params[:q].present?
      search_term = "%#{params[:q]}%"
    else 
      search_term = "%#{params[:term]}%"
    end
    @users = User.where("users.full_name like ?", search_term).order("full_name ASC")
    respond_to do |format|
      format.html #render search.html.erb
      format.json { render json: @users.as_json }
    end
  end

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
    @user = User.new(user_params)
    begin
      @user.save!
      flash[:notice] = "You have successfully created an account.  "
      if current_user.try(:admin?)
        flash[:notice] += "Now, you can set up the new user's first year of membership."
        redirect_to new_user_membership_path(@user) and return
      else
        UserSession.new(@user).save
        redirect_to root_url and return
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Unable to create this user.  See explanation below"
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user, :message => "You may only edit your own account."
    
    @user.attributes = user_params
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

  private

  def user_params
    params.require(:user).permit(:full_name,
                                 :nickname,
                                 :email,
                                 :password,
                                 :phone_number, 
                                 :street_address_1,
                                 :street_address_2, 
                                 :city,
                                 :state, 
                                 :zip,
                                 :share_email,
                                 :share_phone,
                                 :share_address,
                                 :store_affiliation,
                                 :member_since,
                                 :current_through_date, 
                                 :notes,
                                 :board_member,
                                 :lifetime,
                                 :admin,
                                 :former_member,
                                 competitor_attributes: [
                                  :bio, 
                                  :id
                                 ])
  end

end
