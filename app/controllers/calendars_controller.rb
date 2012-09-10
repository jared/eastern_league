class CalendarsController < ApplicationController

  def show
    @season = Season.current
    @events = @season.events.calendar

    @past_seasons = Season.where(:year => 2012)
  end

end
