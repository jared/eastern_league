class StandingsController < ApplicationController
  
  def index
    @season = Season.current
    @standings = @season.standings.group_by(&:discipline)
  end
  
end
