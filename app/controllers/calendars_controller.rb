class CalendarsController < ApplicationController
  
  def show
    @season = Season.current
    @events = @season.events.calendar
  end
  
end
