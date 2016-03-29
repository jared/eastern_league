class CalendarsController < ApplicationController

  def show
    # @season = Season.current
    # @events = @season.events.calendar

    # @past_seasons = Season.where(current: false).order("year DESC").limit(5)
    @seasons = Season.order("year DESC").limit(5)
  end

end
