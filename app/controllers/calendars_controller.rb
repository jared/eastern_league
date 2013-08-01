class CalendarsController < ApplicationController

  def show
    @season = Season.current
    @events = @season.events.calendar

    @past_seasons = Season.where(:year => [2012,2013]).order("year DESC")
  end

end
