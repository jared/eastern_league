class SeasonsController < ApplicationController
  before_filter :require_user

  def index
    @seasons = Season.order("year DESC")
    authorize! :manage, Season
  end

  def new
    @season = Season.new
    authorize! :manage, Season
  end

  def create
    @season = Season.new(season_params)
    authorize! :manage, Season
    if @season.save
      flash[:notice] = "Created successfully!"
      redirect_to seasons_path
    else
      flash[:error] = "Unable to save your changes.  See explanation below"
      render action: :edit
    end  
  end

  def edit
    @season = Season.find(params[:id])
    authorize! :manage, Season
  end

  def update
    @season = Season.find(params[:id])
    authorize! :manage, Season
    @season.attributes = season_params
    if @season.save
      flash[:notice] = "Update successful!"
      redirect_to seasons_path
    else
      flash[:error] = "Unable to save your changes.  See explanation below"
      render action: :edit
    end
  end

private

  def season_params
    params.require(:season).permit(:year, :start_date, :end_date, :current)
  end

end
