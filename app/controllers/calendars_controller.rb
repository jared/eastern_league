class CalendarsController < ApplicationController

  def show
    @seasons = Season.order("year DESC").limit(5)
  end

end
