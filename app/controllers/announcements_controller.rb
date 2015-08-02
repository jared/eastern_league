class AnnouncementsController < ApplicationController

  before_filter :require_user, :except => [:show, :index]

  def index
    @announcements = Announcement.order "created_at DESC"
    # authorize! :list, Announcement
  end

  def new
    @announcement = Announcement.new
    authorize! :create, Announcement
  end

  def edit
    @announcement = Announcement.find(params[:id])
    authorize! :update, @announcement
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:notice] = "Announcement has been created."
      redirect_to announcements_path and return
    else
      render :action => :new
    end
  end

  def update
    @announcement = Announcement.find(params[:id])
    authorize! :update, @announcement
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = "Announcement has been updated."
      redirect_to announcements_path and return
    else
      render :action => :edit
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    authorize! :destroy, @announcement
    @announcement.destroy
    flash[:notice] = "Announcement has been deleted."
    redirect_to announcements_path and return
  end

  private

  def announcement_params
    params.require(:announcement).permit(:headline, :body, :created_at)
  end

end
