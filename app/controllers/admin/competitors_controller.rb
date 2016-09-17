class Admin::CompetitorsController < ApplicationController
  
  before_filter :require_user

  def index
    @pairs = Competitor.pairs.alphabetical
    @teams = Competitor.teams.alphabetical
  end

  def new
    @competitor = Competitor.new(pair: params[:pair], team: params[:team])
  end

  def create
    @competitor = Competitor.new(competitor_params)
    if @competitor.save
      flash[:notice] = "Pair/Team record created."
      redirect_to admin_competitors_path and return
    else
      render action: :new
    end
  end

  def edit
    @competitor = Competitor.find(params[:id])
  end

  def update
    @competitor = Competitor.find(params[:id])
    if @competitor.update_attributes(competitor_params)
      flash[:notice] = "Pair/Team record saved."
      redirect_to admin_competitors_path and return
    else
      render action: :new
    end
  end


  protected

  def competitor_params
    params.require(:competitor).permit!
  end

end
