class StandingsController < ApplicationController

  def index
    @season = params[:season_id] ? Season.find(params[:season_id]) : Season.current
    @standings = @season.standings.group_by(&:discipline)
  end

  def calculate
    Standing.calculate_standings(Season.current)
    flash[:notice] = "Standings have been updated for this season."
    redirect_to standings_path
  end

  def calculate_final
    Standing.calculate_standings(Season.current, true)
    flash[:notice] = "Final Standings have been updated for this season."
    redirect_to standings_path
  end

end
