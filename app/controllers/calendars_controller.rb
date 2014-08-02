class CalendarsController < ApplicationController

  def show
    @season = Season.current
    @events = @season.events.calendar

    @past_seasons = Season.where(:year => [2012,2013,2014]).order("year DESC")
  end

end
